-- Insert data de usuarios
INSERT INTO usuarios (nombre, apellido, email, estado) VALUES
('Juan', 'Pérez', 'juan.perez@example.com', TRUE),
('María', 'Gómez', 'maria.gomez@example.com', TRUE),
('Carlos', 'López', 'carlos.lopez@example.com', TRUE),
('Ana', 'Martínez', 'ana.martinez@example.com', TRUE),
('Luis', 'Hernández', 'luis.hernandez@example.com', TRUE);

-- Insert data de lugares
INSERT INTO lugares (nombre, cantidad_asientos, direccion, estado) VALUES
('Explanada cayala', 5000, 'Bulevar Austriaco, Zona 16, Guatemala', 'Disponible');

-- Insert data de artistas
INSERT INTO artistas (nombre, genero) VALUES
('Coldplay', 'Rock'),
('Shakira', 'Pop'),
('Bad Bunny', 'Reggaeton');

-- Insert data de eventos
INSERT INTO eventos (lugar_id, fecha_hora_inicio, estado) VALUES
(1, '2025-05-15 20:00:00', 'Vigente');

-- Insert data de lineup
INSERT INTO lineup (evento_id, artista_id, fecha, hora_inicio, hora_final) VALUES
(1, 1, '2025-05-15', '2025-05-15 20:00:00', '2025-05-15 21:30:00'), -- Coldplay
(1, 2, '2025-05-15', '2025-05-15 21:45:00', '2025-05-15 23:00:00'), -- Shakira
(1, 3, '2025-05-15', '2025-05-15 23:15:00', '2025-05-16 00:30:00'); -- Bad Bunny

-- Insert data de localidades
INSERT INTO localidades (localidad, cantidad_asientos, evento_id, precio) VALUES
('VIP', 500, 1, 3000.00),
('General', 4500, 1, 1500.00);

-- Insert data de asientos
INSERT INTO asientos (codigo, localidad_id, fila) VALUES
('VIP1', 1, 'A'),
('VIP2', 1, 'A'),
('VIP3', 1, 'A'),
('GEN1', 2, 'G'),
('GEN2', 2, 'G'),
('GEN3', 2, 'G'),
('GEN4', 2, 'G'),
('GEN5', 2, 'G'),
('GEN6', 2, 'G');


-- Insert data de tickets
INSERT INTO tickets (usuario_id, evento_id, asiento_id, beneficiario, estado) VALUES

-- Insert data de transacciones
INSERT INTO transacciones (usuario_id, monto_total, estado) VALUES
(1, 6000.00, 'Pendiente'),
(2, 3000.00, 'Completado'),
(3, 1500.00, 'Pendiente'),
(4, 1500.00, 'Completado'),
(5, 1500.00, 'Pendiente'),
(5, 4500.00, 'Completado');

-- Insert data de transacciones_detalles
INSERT INTO transacciones_detalles (transaccion_id, ticket_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6),
(6, 7),
(6, 8),
(6, 9); 

-- Insert data de transacciones_pagos
INSERT INTO transacciones_pagos (transaccion_id, metodo_pago, monto_pagado) VALUES
(2, 'Tarjeta de crédito', 3000.00),
(4, 'Efectivo', 1500.00),
(6, 'Transferencia', 4500.00);