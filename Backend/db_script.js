const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

const cn = {
  user: 'postgres',
  host: 'localhost',
  password: 'Neko1508',
  port: 5432,
  database: 'tickets_db'
};

async function startDB() {
    const client = new Client(cn);
    try {
      await client.connect();
      console.log('Conectado a la DB');
  
      const sqlFilePath = path.join(__dirname, '..', 'DB', 'ddl.sql');
      const ddlScript = fs.readFileSync(sqlFilePath, 'utf-8');
      await client.query(ddlScript);

      console.log('ddl.sql ejecutado!');

    } catch (err) {
      console.error('Error al crear tablas', err);
    } finally {
      await client.end();
      console.log('Desconectado de la DB');
    }
  }

module.exports = { cn, startDB };
