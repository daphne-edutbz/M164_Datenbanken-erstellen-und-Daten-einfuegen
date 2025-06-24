-- 1. CREATE SCHEMA
CREATE SCHEMA IF NOT EXISTS firma_db DEFAULT CHARACTER SET utf8mb4;
USE firma_db;

-- 2. CREATE TABLES
-- Tabelle: tbl_fahrer
CREATE TABLE IF NOT EXISTS tbl_fahrer (
    fahrer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    vorname VARCHAR(30),
    telefonnummer VARCHAR(12)
) DEFAULT CHARSET = utf8mb4;

-- Tabelle: tbl_disponent
CREATE TABLE IF NOT EXISTS tbl_disponent (
    disponent_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    vorname VARCHAR(30),
    telefonnummer VARCHAR(12)
) DEFAULT CHARSET = utf8mb4;

-- 3. DROP TABLE
DROP TABLE IF EXISTS tbl_disponent;

-- 4. Wiederherstellen der gelöschten Tabelle
CREATE TABLE IF NOT EXISTS tbl_disponent (
    disponent_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    vorname VARCHAR(30),
    telefonnummer VARCHAR(12)
) DEFAULT CHARSET = utf8mb4;

-- 5. Generalisierung: neue Tabelle tbl_mitarbeiter
CREATE TABLE IF NOT EXISTS tbl_mitarbeiter (
    ma_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    vorname VARCHAR(30),
    geburtsdatum DATETIME,
    telefonnummer VARCHAR(12),
    einkommen FLOAT(10,2)
) DEFAULT CHARSET = utf8mb4;

-- 6. ALTER TABLE MODIFY CHARSET für Name und Vorname
ALTER TABLE tbl_mitarbeiter 
MODIFY name VARCHAR(50) CHARACTER SET latin1;

ALTER TABLE tbl_mitarbeiter 
MODIFY vorname VARCHAR(30) CHARACTER SET latin1;

-- 7. ALTER TABLE DROP COLUMN
ALTER TABLE tbl_fahrer 
DROP COLUMN name,
DROP COLUMN vorname,
DROP COLUMN telefonnummer;

ALTER TABLE tbl_disponent 
DROP COLUMN name,
DROP COLUMN vorname,
DROP COLUMN telefonnummer;

-- 8. Spezialisierung: Fremdschlüssel hinzufügen
-- Voraussetzung: tbl_fahrer und tbl_disponent sind Spezialisierungen von tbl_mitarbeiter
-- Daher benötigen diese Tabellen eine ma_id, die auf tbl_mitarbeiter verweist

-- tbl_fahrer mit Fremdschlüssel
ALTER TABLE tbl_fahrer 
ADD COLUMN ma_id INT,
ADD CONSTRAINT fk_fahrer_ma
    FOREIGN KEY (ma_id) REFERENCES tbl_mitarbeiter(ma_id)
    ON DELETE CASCADE;

-- tbl_disponent mit Fremdschlüssel
ALTER TABLE tbl_disponent 
ADD COLUMN ma_id INT,
ADD CONSTRAINT fk_disponent_ma
    FOREIGN KEY (ma_id) REFERENCES tbl_mitarbeiter(ma_id)
    ON DELETE CASCADE;
