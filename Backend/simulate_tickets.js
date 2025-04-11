const { Worker } = require('worker_threads');
const { Console } = require('console');
const { Transform } = require('stream');

function createWorker(threadId, seatCategory, isolationLevel) {
    return new Promise((resolve, reject) => {
        const worker = new Worker('./worker.js', {
            workerData: { threadId, seatCategory, isolationLevel }
        });

        worker.on('message', resolve);
        worker.on('error', reject);
        worker.on('exit', (code) => {
            if (code !== 0) reject(new Error(`Worker stopped with code ${code}`));
        });
    });
}

async function runScenario(concurrent, category, isolationLevel) {
    console.log(`Running scenario: ${concurrent} users, ${isolationLevel}, ${category}`);
    
    // Run workers in batches to prevent memory issues
    const batchSize = 5;
    const batches = Math.ceil(concurrent / batchSize);
    let successful = 0;
    let failed = 0;
    let totalTime = 0;
    
    for (let i = 0; i < batches; i++) {
        const currentBatchSize = Math.min(batchSize, concurrent - (i * batchSize));
        const workers = Array.from({ length: currentBatchSize }, (_, j) => 
            createWorker(i * batchSize + j + 1, category, isolationLevel)
        );

        const results = await Promise.all(workers);
        successful += results.filter(r => r.success).length;
        failed += results.filter(r => !r.success).length;
        totalTime += results.reduce((acc, r) => acc + r.executionTime, 0);
        
        // Add delay between batches
        await new Promise(resolve => setTimeout(resolve, 500));
    }

    return {
        concurrent,
        isolationLevel,
        category,
        successful,
        failed,
        avgTime: Math.round(totalTime / concurrent)
    };
}

function createTable(data) {
    const ts = new Transform({
        transform(chunk, enc, cb) { cb(null, chunk) }
    });
    const table = new Console({ stdout: ts });
    table.table(data);
    return (ts.read() || '').toString();
}

async function runSimulation() {
    const scenarios = [];
    const users = [5, 10, 20, 30];
    const categories = ['VIP', 'GEN'];
    const isolationLevels = ['READ COMMITTED', 'REPEATABLE READ', 'SERIALIZABLE'];

    for (const level of isolationLevels) {
        for (const category of categories) {
            for (const count of users) {
                const result = await runScenario(count, category, level);
                scenarios.push(result);
                await new Promise(resolve => setTimeout(resolve, 2000)); // Increased cool down
                
                if (global.gc) {
                    global.gc(); // Force garbage collection if available
                }
            }
        }
    }

    console.log('\nSimulation Results:');
    console.log(createTable(scenarios.map(s => ({
        'Users': s.concurrent,
        'Category': s.category,
        'Isolation': s.isolationLevel,
        'Success': s.successful,
        'Failed': s.failed,
        'Avg Time(ms)': s.avgTime
    }))));
}

runSimulation().catch(console.error);
