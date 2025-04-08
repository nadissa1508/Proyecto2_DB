-- Tabla de usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    estado BOOLEAN,
    CONSTRAINT chk_email_format CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$')
);

-- Tabla de lugares
CREATE TABLE lugares (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cantidad_asientos INTEGER NOT NULL CHECK (cantidad_asientos > 0),
    direccion VARCHAR(255) NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Disponible', 'En mantenimiento', 'En construcción'))
);

-- Tabla de artistas
CREATE TABLE artistas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    genero VARCHAR(100) NOT NULL
);

-- Tabla de eventos
CREATE TABLE eventos (
    id SERIAL PRIMARY KEY,
    lugar_id INTEGER NOT NULL REFERENCES lugares(id),
    fecha_hora_inicio TIMESTAMP NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Vigente', 'Aplazado', 'Cancelado')),
    CONSTRAINT chk_fecha_futura CHECK (fecha_hora_inicio > CURRENT_TIMESTAMP)
);

-- Tabla de lineup (artistas por evento)
CREATE TABLE lineup (
    id SERIAL PRIMARY KEY,
    evento_id INTEGER NOT NULL REFERENCES eventos(id),
    artista_id INTEGER NOT NULL REFERENCES artistas(id),
    fecha DATE NOT NULL,
    hora_inicio TIMESTAMP NOT NULL,
    hora_final TIMESTAMP NOT NULL,
    CONSTRAINT chk_hora_valida CHECK (hora_final > hora_inicio),
    CONSTRAINT uniq_lineup_evento_artista UNIQUE (evento_id, artista_id, fecha)
);

-- Tabla de localidades (zonas con precios diferentes)
CREATE TABLE localidades (
    id SERIAL PRIMARY KEY,
    localidad VARCHAR(255) NOT NULL UNIQUE,
    cantidad_asientos INTEGER NOT NULL CHECK (cantidad_asientos > 0),
    evento_id INTEGER NOT NULL REFERENCES eventos(id),
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0)
);

-- Tabla de asientos
CREATE TABLE asientos (
    codigo VARCHAR(255) PRIMARY KEY,
    localidad_id INTEGER NOT NULL REFERENCES localidades(id),
    fila VARCHAR(10) NOT NULL
);

-- Tabla de tickets
CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id),
    evento_id INTEGER NOT NULL REFERENCES eventos(id),
    asiento_id VARCHAR(255) NOT NULL REFERENCES asientos(codigo),
    beneficiario VARCHAR(255) NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Reservado', 'Pagado', 'Cancelado')),
    CONSTRAINT uniq_asiento_evento UNIQUE (evento_id, asiento_id)
);

-- Tabla de transacciones
CREATE TABLE transacciones (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id),
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    monto_total DECIMAL(10, 2) NOT NULL CHECK (monto_total > 0),
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Pendiente', 'Completado', 'Fallido'))
);

-- Tabla de detalles de transacciones (permite saber los tickets que se compraron en una transaccion)
CREATE TABLE transacciones_detalles (
    id SERIAL PRIMARY KEY,
    transaccion_id INTEGER NOT NULL REFERENCES transacciones(id),
    ticket_id INTEGER NOT NULL REFERENCES tickets(id),
    CONSTRAINT uniq_ticket_transaccion UNIQUE (ticket_id)
);

-- Tabla de pagos (métodos de pago utilizados por transacción)
-- permite que que paguen los tickets de diferentes formas
CREATE TABLE transacciones_pagos (
    id SERIAL PRIMARY KEY,
    transaccion_id INTEGER NOT NULL REFERENCES transacciones(id),
    metodo_pago VARCHAR(20) NOT NULL CHECK (metodo_pago IN ('Tarjeta de crédito', 'Efectivo', 'Transferencia')),
    monto_pagado DECIMAL(10, 2) NOT NULL CHECK (monto_pagado > 0)
);

