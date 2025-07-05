-- Datenbank Backup - Vertraulich
-- Erstellt am: 2024-03-15 14:30:00

-- Benutzer Tabelle
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sensible Daten
INSERT INTO users (username, email, password_hash) VALUES
('admin', 'admin@company.com', '$2a$12$hashed_password_here'),
('john.doe', 'john@company.com', '$2a$12$another_hash'),
('jane.smith', 'jane@company.com', '$2a$12$third_hash');

-- Finanzdaten
CREATE TABLE financial_data (
    id SERIAL PRIMARY KEY,
    account_number VARCHAR(20) NOT NULL,
    balance DECIMAL(15,2) NOT NULL,
    transaction_date TIMESTAMP NOT NULL
);

INSERT INTO financial_data (account_number, balance, transaction_date) VALUES
('DE12345678901234567890', 1500000.00, '2024-03-15 10:00:00'),
('DE09876543210987654321', 2500000.00, '2024-03-15 11:00:00');
