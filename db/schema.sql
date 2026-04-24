-- ============================================================
-- Ștergem tabelele dacă există deja (util la re-rulare)
-- Ordinea contează: întâi tabelele cu FK, apoi cele de bază
-- ============================================================
DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS users;

-- ============================================================
-- Tipuri enum custom
-- Definim înainte de tabele, că sunt referite în coloane
-- ============================================================

-- Rolul unui utilizator în sistem
CREATE TYPE user_role AS ENUM ('user', 'admin');

-- Statusul unei rezervări
CREATE TYPE reservation_status AS ENUM ('pending', 'confirmed', 'cancelled');

-- Clasa unui zbor
CREATE TYPE flight_class AS ENUM ('economy', 'business', 'first');


-- ============================================================
-- Tabelul users
-- Gestionat de Auth Service prin IO Service
-- ============================================================
CREATE TABLE users (
    id              SERIAL PRIMARY KEY,
    email           VARCHAR(255) NOT NULL UNIQUE,  -- unic, folosit la login
    password_hash   VARCHAR(255) NOT NULL,          -- bcrypt hash, niciodată plain text
    role            user_role NOT NULL DEFAULT 'user',
    created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);


-- ============================================================
-- Tabelul flights
-- Populat de admin, citit de Business Logic Service prin IO Service
-- ============================================================
CREATE TABLE flights (
    id                SERIAL PRIMARY KEY,
    origin            CHAR(3) NOT NULL,   -- codul IATA al aeroportului (ex: OTP, LHR)
    destination       CHAR(3) NOT NULL,
    departure_time    TIMESTAMP NOT NULL,
    arrival_time      TIMESTAMP NOT NULL,
    class             flight_class NOT NULL DEFAULT 'economy',
    price             DECIMAL(10, 2) NOT NULL,  -- prețul per pasager
    total_seats       INT NOT NULL,
    available_seats   INT NOT NULL,
    created_at        TIMESTAMP NOT NULL DEFAULT NOW(),

    -- Validări la nivel de DB, ca să nu depindem doar de aplicație
    CONSTRAINT chk_seats CHECK (available_seats >= 0),
    CONSTRAINT chk_seats_total CHECK (available_seats <= total_seats),
    CONSTRAINT chk_price CHECK (price > 0),
    CONSTRAINT chk_times CHECK (arrival_time > departure_time)
);


-- ============================================================
-- Tabelul reservations
-- Legătura dintre un user și un zbor
-- ============================================================
CREATE TABLE reservations (
    id            SERIAL PRIMARY KEY,
    user_id       INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    flight_id     INT NOT NULL REFERENCES flights(id) ON DELETE CASCADE,
    status        reservation_status NOT NULL DEFAULT 'pending',
    passengers    INT NOT NULL DEFAULT 1,
    total_price   DECIMAL(10, 2) NOT NULL,  -- calculat la creare: price * passengers
    created_at    TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT chk_passengers CHECK (passengers >= 1)
);


-- ============================================================
-- Indexuri
-- Accelerează query-urile frecvente fără să schimbe logica
-- ============================================================

-- Căutăm des zboruri după origine + destinație + dată
CREATE INDEX idx_flights_origin_dest ON flights(origin, destination);
CREATE INDEX idx_flights_departure ON flights(departure_time);

-- Căutăm des rezervările unui user anume
CREATE INDEX idx_reservations_user ON reservations(user_id);
CREATE INDEX idx_reservations_flight ON reservations(flight_id);