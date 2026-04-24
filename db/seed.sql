-- ============================================================
-- Date de test — rulate automat după schema.sql
-- ============================================================


-- ============================================================
-- Useri de test
-- Parola pentru ambii este: "password123"
-- Hash-ul e generat cu bcrypt, cost factor 10
-- ============================================================
INSERT INTO users (email, password_hash, role) VALUES
(
    'admin@flights.com',
    '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    'admin'
),
(
    'user@flights.com',
    '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    'user'
);


-- ============================================================
-- Zboruri de test
-- OTP = Otopeni, LHR = Londra, CDG = Paris,
-- FCO = Roma, AMS = Amsterdam, BCN = Barcelona
-- ============================================================
INSERT INTO flights 
    (origin, destination, departure_time, arrival_time, class, price, total_seats, available_seats)
VALUES
-- București → Londra
('OTP', 'LHR', '2025-06-01 08:00:00', '2025-06-01 11:00:00', 'economy',  199.99, 180, 120),
('OTP', 'LHR', '2025-06-01 14:00:00', '2025-06-01 17:00:00', 'business', 599.99,  20,  15),

-- București → Paris
('OTP', 'CDG', '2025-06-02 09:00:00', '2025-06-02 11:30:00', 'economy',  149.99, 180, 180),
('OTP', 'CDG', '2025-06-02 16:00:00', '2025-06-02 18:30:00', 'business', 499.99,  20,   8),

-- București → Roma
('OTP', 'FCO', '2025-06-03 07:30:00', '2025-06-03 09:30:00', 'economy',  129.99, 150, 150),

-- București → Amsterdam
('OTP', 'AMS', '2025-06-04 10:00:00', '2025-06-04 12:30:00', 'economy',  179.99, 180,  60),

-- București → Barcelona
('OTP', 'BCN', '2025-06-05 06:00:00', '2025-06-05 09:00:00', 'economy',  159.99, 150, 100),
('OTP', 'BCN', '2025-06-05 06:00:00', '2025-06-05 09:00:00', 'first',    899.99,  10,  10),

-- Retur: Londra → București
('LHR', 'OTP', '2025-06-08 12:00:00', '2025-06-08 17:00:00', 'economy',  199.99, 180, 180),
('LHR', 'OTP', '2025-06-08 18:00:00', '2025-06-08 23:00:00', 'business', 599.99,  20,  20);


-- ============================================================
-- O rezervare de test — userul 2 pe primul zbor
-- ============================================================
INSERT INTO reservations (user_id, flight_id, status, passengers, total_price)
VALUES (2, 1, 'confirmed', 2, 399.98);  -- 2 pasageri x 199.99

-- Actualizăm locurile disponibile corespunzător
UPDATE flights SET available_seats = available_seats - 2 WHERE id = 1;