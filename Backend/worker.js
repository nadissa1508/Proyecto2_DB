const { workerData, parentPort } = require('worker_threads');
const { Pool } = require('pg');

const pool = new Pool({
    user: process.env.DB_USER || 'postgres',
    host: process.env.DB_HOST || 'localhost',
    password: process.env.DB_PASSWORD || 'passwordxd',
    port: process.env.DB_PORT || 5434,
    database: process.env.DB_NAME || 'tickets_db',
    max: 20,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
});

async function reserveSeat(threadId, asientoId, isolationLevel) {
    const client = await pool.connect();
    try {
        await client.query(`BEGIN ISOLATION LEVEL ${isolationLevel}`);

        // Check if the seat is already reserved
        const checkQuery = `
            SELECT COUNT(*) AS count
            FROM tickets
            WHERE asiento_id = $1
        `;
        const checkResult = await client.query(checkQuery, [asientoId]);

        if (parseInt(checkResult.rows[0].count, 10) === 0) {
            // Reserve the seat if it's not already reserved
            const userId = Math.floor(Math.random() * 5) + 1; // Random user ID between 1 and 5
            const eventoId = 1; // Assuming event ID is 1
            const beneficiario = `User${threadId}`;
            const estado = 'Reservado';

            const insertQuery = `
                INSERT INTO tickets (usuario_id, evento_id, asiento_id, beneficiario, estado)
                VALUES ($1, $2, $3, $4, $5)
            `;
            await client.query(insertQuery, [userId, eventoId, asientoId, beneficiario, estado]);
            await client.query('COMMIT');
            parentPort.postMessage(`Thread ${threadId}: Successfully reserved seat ${asientoId}`);
            return true;
        } else {
            await client.query('ROLLBACK');
            parentPort.postMessage(`Thread ${threadId}: Failed to reserve seat ${asientoId} (already reserved)`);
            return false;
        }
    } catch (error) {
        await client.query('ROLLBACK');
        parentPort.postMessage(`Thread ${threadId}: Error - ${error.message}`);
        return false;
    } finally {
        client.release();
    }
}

reserveSeat(workerData.threadId, workerData.asientoId, workerData.isolationLevel);