-- Clear ALL existing data first
TRUNCATE TABLE transacciones_pagos, transacciones_detalles, tickets, asientos, localidades, 
             lineup, eventos, artistas, lugares, usuarios CASCADE;

-- Reset sequence
ALTER SEQUENCE usuarios_id_seq RESTART WITH 1;
ALTER SEQUENCE lugares_id_seq RESTART WITH 1;
ALTER SEQUENCE eventos_id_seq RESTART WITH 1;
ALTER SEQUENCE localidades_id_seq RESTART WITH 1;

-- Insert test usuarios
INSERT INTO usuarios (nombre, apellido, email, estado) VALUES
('Test', 'User1', 'test1@test.com', TRUE),
('Test', 'User2', 'test2@test.com', TRUE),
('Test', 'User3', 'test3@test.com', TRUE),
('Test', 'User4', 'test4@test.com', TRUE),
('Test', 'User5', 'test5@test.com', TRUE);

-- Insert test lugar
INSERT INTO lugares (nombre, cantidad_asientos, direccion, estado) VALUES
('Test Venue', 1000, 'Test Address 123', 'Disponible');

-- Insert test evento
INSERT INTO eventos (lugar_id, fecha_hora_inicio, estado) VALUES
(1, '2024-12-31 20:00:00', 'Vigente');

-- Insert test localidades with correct counts
INSERT INTO localidades (localidad, cantidad_asientos, evento_id, precio) VALUES
('VIP', 200, 1, 1000.00),    
('General', 300, 1, 500.00);  

-- Clear existing asientos
DELETE FROM asientos;

-- VIP seats (200 seats)
INSERT INTO asientos (codigo, localidad_id, fila)
SELECT 
    'VIP' || LPAD(n::text, 3, '0'),
    1,
    CHR(65 + ((n-1)/40)::integer) -- Generates rows A-E
FROM generate_series(1, 200) n;

-- General seats (300 seats)
INSERT INTO asientos (codigo, localidad_id, fila)
SELECT 
    'GEN' || LPAD(n::text, 3, '0'),
    2,
    CHR(65 + ((n-1)/60)::integer) -- Generates rows A-E
FROM generate_series(1, 300) n;

-- Verify seat counts
DO $$
DECLARE
    vip_count INTEGER;
    gen_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO vip_count FROM asientos WHERE codigo LIKE 'VIP%';
    SELECT COUNT(*) INTO gen_count FROM asientos WHERE codigo LIKE 'GEN%';
    
    RAISE NOTICE 'VIP seats count: %', vip_count;
    RAISE NOTICE 'General seats count: %', gen_count;
    RAISE NOTICE 'Reserved tickets count: %', (SELECT COUNT(*) FROM tickets);
END $$;
