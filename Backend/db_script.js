const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

const cn = {
  user: 'postgres',
  host: 'localhost',
  password: 'passwordxd', 
  port: 5434,
  database: 'tickets_db'
};

async function startDB() {
    const client = new Client(cn);
    try {
      await client.connect();
      console.log('Conectado a la DB');

      // creacion de tablas
      try {
        const sqlFilePath = path.join(__dirname, '..', 'DB', 'ddl.sql');
        const ddlScript = fs.readFileSync(sqlFilePath, 'utf-8');
        await client.query(ddlScript);

        console.log('ddl.sql ejecutado!');

      } catch (err) {
        console.error('Error al crear tablas', err);
      }

      // insercion de datos
      try {
        sqlFilePath = path.join(__dirname, '..', 'DB', 'data.sql');
        const dataScript = fs.readFileSync(sqlFilePath, 'utf-8');
        await client.query(dataScript);

        console.log('data.sql ejecutado!');

      } catch (err) {
        console.error('Error al insertar data', err);
      }

    } catch (err) {
      console.error('No se pudo conectar a la DB', err);
    } finally {
      await client.end();
      console.log('Desconectado de la DB');
    }
  }

module.exports = { cn, startDB };
