const { workerData, parentPort } = require('worker_threads');
const { Pool } = require('pg');

const pool = new Pool({
    user: process.env.DB_USER || 'postgres',
    host: process.env.DB_HOST || 'localhost',
    password: process.env.DB_PASSWORD || 'passwordxd',
    port: process.env.DB_PORT || 5434,
    database: process.env.DB_NAME || 'tickets_db',
    max: 5, // Reduced pool size
    min: 0,
    idleTimeoutMillis: 1000,
    connectionTimeoutMillis: 1000,
    maxUses: 100 // Limit connection reuse
});

async function reserveSeat() {
    const client = await pool.connect();
    const startTime = Date.now();
    const { threadId, seatCategory, isolationLevel } = workerData;
    
    try {
        await client.query('BEGIN');
        await client.query(`SET TRANSACTION ISOLATION LEVEL ${isolationLevel}`);

        // Simplified query
        const seatResult = await client.query(`
            SELECT a.codigo, e.id as evento_id
            FROM asientos a
            JOIN localidades l ON a.localidad_id = l.id
            JOIN eventos e ON l.evento_id = e.id
            WHERE l.localidad = $1
            AND NOT EXISTS (
                SELECT 1 FROM tickets t 
                WHERE t.asiento_id = a.codigo
            )
            LIMIT 1
            FOR UPDATE SKIP LOCKED
        `, [seatCategory]);

        if (seatResult.rows.length === 0) {
            throw new Error('No seats available');
        }

        const seat = seatResult.rows[0];

        await client.query(`
            INSERT INTO tickets (usuario_id, evento_id, asiento_id, beneficiario, estado)
            VALUES ($1, $2, $3, $4, $5)
        `, [1, seat.evento_id, seat.codigo, `User ${threadId}`, 'Reservado']);

        await client.query('COMMIT');
        
        const endTime = Date.now();
        parentPort.postMessage({
            success: true,
            message: `Thread ${threadId}: Reserved seat ${seat.codigo}`,
            executionTime: endTime - startTime
        });
    } catch (error) {
        await client.query('ROLLBACK');
        const endTime = Date.now();
        parentPort.postMessage({
            success: false,
            message: `Thread ${threadId}: ${error.message}`,
            executionTime: endTime - startTime
        });
    } finally {
        client.release();
        if (process.memoryUsage().heapUsed > 500 * 1024 * 1024) { // 500MB limit
            global.gc && global.gc(); // Force garbage collection if available
        }
    }
}

// Cleanup function
async function cleanup() {
    await pool.end();
    process.exit(0);
}

process.on('exit', cleanup);
process.on('SIGINT', cleanup);
process.on('SIGTERM', cleanup);

reserveSeat().catch(error => {
    parentPort.postMessage({
        success: false,
        message: `Thread ${workerData.threadId}: Error - ${error.message}`,
        executionTime: 0
    });
    cleanup();
});
