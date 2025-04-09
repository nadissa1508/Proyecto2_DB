const { Worker } = require('worker_threads');
const readline = require('readline');

function createWorker(threadId, asientoId, isolationLevel) {
    return new Promise((resolve, reject) => {
        const worker = new Worker('./worker.js', {
            workerData: { threadId, asientoId, isolationLevel }
        });

        worker.on('message', (message) => {
            console.log(message);
            if (message.includes('Successfully reserved')) {
                resolve(true);
            } else {
                resolve(false);
            }
        });

        worker.on('error', (error) => {
            console.error(`Thread ${threadId} encountered an error:`, error);
            reject(error);
        });

        worker.on('exit', (code) => {
            if (code !== 0) {
                reject(new Error(`Thread ${threadId} exited with code ${code}`));
            }
        });
    });
}

// Main function
async function main() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    rl.question('Cuantos hilos desea ver? ', async (threads) => {
        rl.question('Que asiento desea reservar? (e.g., GEN1, VIP1) ', async (asientoId) => {
            rl.question('Que nivel de aislamiento quiere usar? (READ COMMITTED, REPEATABLE READ, SERIALIZABLE) ', async (isolationLevel) => {
                const promises = [];
                const startTime = Date.now();

                for (let i = 1; i <= threads; i++) {
                    promises.push(createWorker(i, asientoId, isolationLevel.toUpperCase()));
                }

                try {
                    const results = await Promise.all(promises);
                    const successfulReservations = results.filter(result => result).length;
                    const endTime = Date.now();
                    const elapsedTime = (endTime - startTime) / 1000;

                    console.log(`\nSimulation complete!`);
                    console.log(`Threads that successfully reserved the seat: ${successfulReservations}`);
                    console.log(`Time taken: ${elapsedTime} seconds`);
                } catch (error) {
                    console.error('Error during simulation:', error);
                } finally {
                    rl.close();
                }
            });
        });
    });
}

main();