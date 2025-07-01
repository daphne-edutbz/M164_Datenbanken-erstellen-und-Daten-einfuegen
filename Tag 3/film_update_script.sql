-- Vorbereitung: Fehler 1175 vermeiden (nur bei MySQL Workbench nötig)
-- SET SQL_SAFE_UPDATES = 0;

-- 1. Update: Regisseur "Cohen" → "Etan Cohen"
UPDATE dvd_sammlung
SET regisseur = 'Etan Cohen'
WHERE regisseur = 'Cohen';

-- 2. Update: Filmlänge von "Angst" korrigieren
UPDATE dvd_sammlung
SET laenge_minuten = 120
WHERE film = 'Angst' AND laenge_minuten != 120;

-- 3. Umbenennung der Tabelle in "bluray_sammlung" (wenn noch nicht umbenannt)
-- Prüfen ob Tabelle existiert, dann umbenennen
DROP TABLE IF EXISTS bluray_sammlung_tmp;

CREATE TABLE IF NOT EXISTS bluray_sammlung_tmp LIKE dvd_sammlung;

INSERT INTO bluray_sammlung_tmp SELECT * FROM dvd_sammlung;

DROP TABLE IF EXISTS bluray_sammlung;

RENAME TABLE bluray_sammlung_tmp TO bluray_sammlung;

-- 4. Spalte "preis" hinzufügen, falls sie noch nicht existiert
ALTER TABLE bluray_sammlung
ADD COLUMN IF NOT EXISTS preis DECIMAL(5,2);

-- 5. Film "Angriff auf Rom" von Steven Burghofer entfernen
DELETE FROM bluray_sammlung
WHERE film = 'Angriff auf Rom' AND regisseur = 'Steven Burghofer';

-- 6. Spalte "film" in "kinofilme" umbenennen
ALTER TABLE bluray_sammlung
CHANGE COLUMN film kinofilme VARCHAR(255);

-- 7. Spalte "nummer" löschen (falls vorhanden)
ALTER TABLE bluray_sammlung
DROP COLUMN IF EXISTS nummer;

-- 8. Tabelle "bluray_sammlung" löschen (z. B. wenn Firma geschlossen)
DROP TABLE IF EXISTS bluray_sammlung;

-- Optional: Schema löschen, falls vollständig aufgeräumt werden soll
-- DROP SCHEMA IF EXISTS filmeDatenbank;
