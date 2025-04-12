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
('GEN6', 2, 'G'),
('GEN7', 2, 'G'),
('GEN8', 2, 'G'),
('GEN9', 2, 'G'),
('GEN10', 2, 'G'),
('GEN11', 2, 'G'),
('GEN12', 2, 'G'),
('GEN13', 2, 'G'),
('GEN14', 2, 'G'),
('GEN15', 2, 'G'),
('GEN16', 2, 'G'),
('GEN17', 2, 'G'),
('GEN18', 2, 'G'),
('GEN19', 2, 'G'),
('GEN20', 2, 'G'),
('GEN21', 2, 'G'),
('GEN22', 2, 'G'),
('GEN23', 2, 'G'),
('GEN24', 2, 'G'),
('GEN25', 2, 'G'),
('GEN26', 2, 'G'),
('GEN27', 2, 'G'),
('GEN28', 2, 'G'),
('GEN29', 2, 'G'),
('GEN30', 2, 'G'),
('GEN31', 2, 'G'),
('GEN32', 2, 'G'),
('GEN33', 2, 'G'),
('GEN34', 2, 'G'),
('GEN35', 2, 'G'),
('GEN36', 2, 'G'),
('GEN37', 2, 'G'),
('GEN38', 2, 'G'),
('GEN39', 2, 'G'),
('GEN40', 2, 'G'),
('GEN41', 2, 'G'),
('GEN42', 2, 'G'),
('GEN43', 2, 'G'),
('GEN44', 2, 'G'),
('GEN45', 2, 'G'),
('GEN46', 2, 'G'),
('GEN47', 2, 'G'),
('GEN48', 2, 'G'),
('GEN49', 2, 'G'),
('GEN50', 2, 'G'),
('GEN51', 2, 'G'),
('GEN52', 2, 'G'),
('GEN53', 2, 'G'),
('GEN54', 2, 'G'),
('GEN55', 2, 'G'),
('GEN56', 2, 'G'),
('GEN57', 2, 'G'),
('GEN58', 2, 'G'),
('GEN59', 2, 'G'),
('GEN60', 2, 'G'),
('GEN61', 2, 'G'),
('GEN62', 2, 'G'),
('GEN63', 2, 'G'),
('GEN64', 2, 'G'),
('GEN65', 2, 'G'),
('GEN66', 2, 'G'),
('GEN67', 2, 'G'),
('GEN68', 2, 'G'),
('GEN69', 2, 'G'),
('GEN70', 2, 'G'),
('GEN71', 2, 'G'),
('GEN72', 2, 'G'),
('GEN73', 2, 'G'),
('GEN74', 2, 'G'),
('GEN75', 2, 'G'),
('GEN76', 2, 'G'),
('GEN77', 2, 'G'),
('GEN78', 2, 'G'),
('GEN79', 2, 'G'),
('GEN80', 2, 'G'),
('GEN81', 2, 'G'),
('GEN82', 2, 'G'),
('GEN83', 2, 'G'),
('GEN84', 2, 'G'),
('GEN85', 2, 'G'),
('GEN86', 2, 'G');


-- Insert data de tickets
INSERT INTO tickets (usuario_id, evento_id, asiento_id, beneficiario, estado) VALUES
(1, 1, 'VIP1', 'Juan Pérez', 'Reservado'),
(1, 1, 'VIP2', 'Luna Pérez', 'Pagado'),
(2, 1, 'VIP3', 'María Gómez', 'Reservado'),
(3, 1, 'GEN1', 'Carlos López', 'Pagado'),
(4, 1, 'GEN2', 'Ana Martínez', 'Reservado'),
(5, 1, 'GEN3', 'Luis Hernández', 'Reservado'), 
(5, 1, 'GEN4', 'Pedro Ramírez', 'Pagado'),
(5, 1, 'GEN5', 'Sofía López', 'Pagado'),
(5, 1, 'GEN6', 'Andrés García', 'Pagado');

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