# Lernportfolio Modul 164 – Tag 3
- **Name:** Daphne Sibel McNamara
- **Klasse:** AP 24b
- **Modul:** 164 – Datenbanken erstellen und Daten einfügen  
- **Datum:** 27.05.2025
- Miro-Board: https://miro.com/app/board/uXjVI29IW6Y=/

---


## Lernziele für Tag 3
- Ich kann verschiedene Datentypen in MySQL/MariaDB benennen und anwenden
- Ich verstehe komplexe Beziehungsarten in Datenbanken (mc:mc, Rekursion, einfache Hierarchie)
- Ich kann Daten mit SQL-Befehlen (INSERT, UPDATE, DELETE) korrekt bearbeiten
- Ich kenne den Unterschied zwischen DML und DQL und kann SELECT-Abfragen anwenden


## Gelerntes (LEARN)



### Datentypen
| Datentyp                     | MariaDB/MySQL Typ      | Beispiel                  | Bemerkung / Einstellungen                 |
| ---------------------------- | ---------------------- | ------------------------- | ----------------------------------------- |
| Ganze Zahlen                 | INT, SMALLINT, TINYINT | INT(11)                   | Ganze Zahlen, Standard für Integer        |
| Natürliche Zahlen            | UNSIGNED INT           | INT(11) UNSIGNED          | Nur positive Werte (inkl. 0)              |
| Festkommazahlen (Dezimal)    | DECIMAL(M,D)           | DECIMAL(6,2) = 1234.56    | M=Gesamtstellen, D=Nachkommastellen       |
| Aufzählungstypen             | ENUM                   | ENUM('rot','grün','blau') | Auswahl aus vorgegebenen Werten           |
| Boolean (logisch)            | BOOLEAN, TINYINT(1)    | TRUE / FALSE              | Wahr/Falsch Werte                         |
| Zeichen (einzelnes Zeichen)  | CHAR(1)                | 'A'                       | Feste Länge 1 Zeichen                     |
| Gleitkommazahlen             | FLOAT, DOUBLE          | FLOAT, DOUBLE             | Ungenaue Dezimalwerte                     |
| Zeichenkette fester Länge    | CHAR(n)                | CHAR(10)                  | Feste Länge n Zeichen                     |
| Zeichenkette variabler Länge | VARCHAR(n)             | VARCHAR(255)              | Variable Länge, bis n Zeichen             |
| Datum und/oder Zeit          | DATE, DATETIME, TIME   | '2025-06-24', '12:34:56'  | Datum, Zeit, oder beides                  |
| Zeitstempel                  | TIMESTAMP              | CURRENT\_TIMESTAMP        | Automatisch Zeitstempel                   |
| Binäre Datenobjekte          | BLOB, VARBINARY        | BLOB (für Bilder)         | Variable Länge, binäre Daten              |
| Verbund                      | SET                    | SET('A','B','C')          | Mehrfachauswahl aus vordefinierten Werten |
| JSON                         | JSON                   | '{"name":"Max"}'          | JSON-Format, strukturierte Daten          |


### Beziehungen in Datenbanken (Tourenplaner-Beispiele)

#### Mehrfachbeziehungen (mc:mc)
- Zwei Tabellen (z.B. tbl_Fahrten und tbl_Orte) haben mehrere unabhängige Beziehungen
- Beispiel: Verschiedene Arten von Orten auf einer Tour
- Umsetzung: Zwischentabelle zur Verknüpfung

  
![image](https://github.com/user-attachments/assets/2fc22d62-6214-4e5a-9fe9-00e382c8ea74)


#### Rekursion (strenge Hierarchie)
- Tabelle bezieht sich auf sich selbst (z.B. Mitarbeiter mit Vorgesetzten)
- Fremdschlüssel zeigt auf denselben Primärschlüssel in der gleichen Tabelle
- Beispiel: Firmenorganisation mit genau einem Vorgesetzten pro Mitarbeiter

  
![image](https://github.com/user-attachments/assets/008cd3be-2912-4854-a159-ba5fe8ad46d4)


#### Einfache Hierarchie mit Zwischentabelle
- Netzwerkstruktur: Mitarbeiter können mehrere Vorgesetzte haben
- Transformationstabelle mit Fremdschlüsseln zu einer Tabelle (tbl_Hierarchie)
- Beispiel: Mehrere Projektleiter

  
![image](https://github.com/user-attachments/assets/8e481714-3310-4f25-87f5-d09fb7f84014)


#### Stücklistenproblem
- Produkt kann sich aus mehreren anderen Produkten zusammensetzen
- Produkte und Komponenten sind in derselben Tabelle gespeichert (tbl_Produkte)
- Umsetzung: Zusätzliche Tabelle (z. B. tbl_Stückliste) für die Zusammensetzungen mit Mengenangabe
- Beispiel: Ein Schrank besteht aus Türen, Regalböden, Schrauben usw.
- Modellierung über Rekursion und eine mc:mc-Beziehung mit Zwischentabelle


![image](https://github.com/user-attachments/assets/b8c50b2f-3dce-415a-88f9-287ede45c34f)



### Datenbearbeitung der Datenbasis (Repetition DML ÜK Modul 106)

#### Auftrag Insert

Gegebene Tabelle:

```sql
CREATE TABLE kunden (
    kunde_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL, 
    vorname VARCHAR(255), 
    nachname VARCHAR(255), 
    land_id INT, 
    wohnort VARCHAR(255)
);
```

**1a)** Heinrich Schmitt aus Zürich, Schweiz (land_id = 2)
```sql
INSERT INTO kunden VALUES (NULL, 'Heinrich', 'Schmitt', 2, 'Zürich');
```

**1b)** Sabine Müller aus Bern, Schweiz
```sql
INSERT INTO kunden VALUES (NULL, 'Sabine', 'Müller', 2, 'Bern');
```

**1c)** Markus Mustermann aus Wien, Österreich (land_id = 1)
```sql
INSERT INTO kunden VALUES (NULL, 'Markus', 'Mustermann', 1, 'Wien');
```

**1d)** Herr Maier (nur Nachname)
```sql
INSERT INTO kunden (nachname) VALUES ('Maier');
```

**1e)** Herr Bulgur aus Sirnach
```sql
INSERT INTO kunden (nachname, wohnort) VALUES ('Bulgur', 'Sirnach');
```

**1f)** Maria Manta
```sql
INSERT INTO kunden (vorname, nachname) VALUES ('Maria', 'Manta');
```


**2a)** Fehler: Kein Tabellenname angegeben
Korretkur:
```sql
INSERT INTO kunden (nachname, wohnort, land_id) VALUES ('Fesenkampp', 'Duis-burg', 3);
```

**2b)** Fehler: Spaltenname in Hochkommas
Korrektur:
```sql
INSERT INTO kunden (vorname) VALUES ('Herbert');
```

**2c)** Fehler: 'Deutschland' ist kein Integer (land_id)
Korrektur:
```sql
INSERT INTO kunden (nachname, vorname, wohnort, land_id) VALUES ('Schulter', 'Albert', 'Duisburg', 1);
```

**2d)** Fehler: Kein Tabellenname, fehlerhafte Spaltenliste
Korrektur:
```sql
INSERT INTO kunden VALUES (NULL, 'Brunhild', 'Sulcher', 1, 'Süderstade');
```

**2e** Fehler: Keine Spaltenliste, AUTO_INCREMENT fehlt
Korrektur:
```sql
INSERT INTO kunden VALUES (NULL, 'Jochen', 'Schmied', 2, 'Solingen');
```

**2f)** Fehler: Leere Werte, kein Bezug zu Spalten
Korrektur:
```sql
INSERT INTO kunden (nachname, land_id) VALUES ('Doppelbrecher', 2);
```

**2g)** Fehler: Falsche Spaltenanzahl
Korrektur:
```sql
INSERT INTO kunden (nachname, vorname, wohnort, land_id) VALUES ('Fesenkampp', 'Christoph', 'Duisburg', 3);
```

**2h)** Kein Fehler
```sql
INSERT INTO kunden (vorname) VALUES ('Herbert');
```

**2i)** Fehler: Strings nicht in Anführungszeichen
Korrektur:
```sql
INSERT INTO kunden (nachname, vorname, wohnort, land_id) VALUES ('Schulter', 'Albert', 'Duisburg', 1);
```

**2j)** Fehler: VALUE statt VALUES, keine Spaltenliste
Korrektur:
```sql
INSERT INTO kunden VALUES (NULL, 'Brunhild', 'Sulcher', 1, 'Süderstade');
```

**2k)**  Fehler:"Solingen" nicht in korrekten Quotes
Korrektur:
```sql
INSERT INTO kunden VALUES (NULL, 'Jochen', 'Schmied', 2, 'Solingen');
```

#### Auftrag Update, delete, alter und drop

**File:** film_update_script.sql

**Skript:**
```sql
-- Achtung: Für UPDATE/DELETE in Workbench mit Safe Updates
-- SET SQL_SAFE_UPDATES = 0; -- Falls Error 1175

-- Aufgabe 1
-- Regisseur «Cohen» → «Etan Cohen»
UPDATE bluray_sammlung
SET regisseur = 'Etan Cohen'
WHERE regisseur = 'Cohen';

-- Falls Tabelle noch dvd_sammlung heißt, zuerst Umbenennen (Aufgabe 3)
-- Damit das Skript idempotent ist, prüfen wir beide Varianten
-- Tipp: MySQL hat kein IF EXISTS beim RENAME TABLE, deshalb tricksen wir mit SELECT
SET @tableExists := (
  SELECT COUNT(*)
  FROM information_schema.tables
  WHERE table_schema = DATABASE() AND table_name = 'dvd_sammlung'
);
SET @renameSQL := IF(@tableExists > 0, 'RENAME TABLE dvd_sammlung TO bluray_sammlung;', 'SELECT 1;');
PREPARE stmt FROM @renameSQL;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Aufgabe 2
-- Film «Angst» Dauer ändern
UPDATE bluray_sammlung
SET dauer = 120
WHERE titel = 'Angst' AND dauer <> 120;

-- Aufgabe 4
-- Spalte «Preis» hinzufügen, wenn noch nicht vorhanden
ALTER TABLE bluray_sammlung
ADD COLUMN IF NOT EXISTS preis DECIMAL(5,2);

-- Aufgabe 5
-- Film «Angriff auf Rom» von Steven Burghofer löschen
DELETE FROM bluray_sammlung
WHERE titel = 'Angriff auf Rom' AND regisseur = 'Steven Burghofer';

-- Aufgabe 6
-- Spalte «filme» → «kinofilme» umbenennen, wenn «filme» existiert
SELECT COUNT(*) INTO @has_filme
FROM information_schema.columns
WHERE table_schema = DATABASE() AND table_name = 'bluray_sammlung' AND column_name = 'filme';

SET @alter_filme := IF(@has_filme > 0,
  'ALTER TABLE bluray_sammlung CHANGE COLUMN filme kinofilme VARCHAR(255);',
  'SELECT 1;'
);
PREPARE stmt FROM @alter_filme;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Aufgabe 7
-- Spalte «nummer» löschen, wenn vorhanden
ALTER TABLE bluray_sammlung
DROP COLUMN IF EXISTS nummer;

-- Aufgabe 8
-- Tabelle löschen, wenn vorhanden
DROP TABLE IF EXISTS bluray_sammlung;
```



### Daten auslesen (Repetition ÜK Modul 106)

**Ziel:** Ich kann mit SELECT-Abfragen Daten aus meiner Filmdatenbank auslesen und gezielt filtern, berechnen und sortieren

**Datenbasis**
Meine Tabelle heißt dvd_sammlung. Sie enthält Felder wie:
- id
- film
- nummer
- regisseur
- länge_minuten

![image](https://github.com/user-attachments/assets/46b33342-4a30-4300-acb1-17bd5bb345ee)


#### Auftrag: Selet

**a. Alle Film-Datensätze ausgeben**
```sql
SELECT * FROM dvd_sammlung;
```

**b. Alle Filmtitel und die jeweils zugehörige Nummer ausgeben**
```sql
SELECT film, nummer FROM dvd_sammlung;
```


**c. Alle Filmtitel und den jeweils zugehörigen Regisseur ausgeben**
```sql
SELECT film, regisseur FROM dvd_sammlung;
```


**d. Liste mit allen Filmen von Quentin Tarantino**
```sql
SELECT * FROM dvd_sammlung
WHERE regisseur = 'Quentin Tarantino';
```


**e. Liste mit allen Filmen von Steven Spielberg**
```sql
SELECT * FROM dvd_sammlung
WHERE regisseur = 'Steven Spielberg';
```


**f. Alle Filme, bei denen der Regisseur den Vornamen „Steven“ hat**
```sql
SELECT * FROM dvd_sammlung
WHERE regisseur LIKE 'Steven%';
```


**g. Alle Filme, die länger als 2 Stunden sind**
2 Stunden = 120 Minuten

```sql
SELECT * FROM dvd_sammlung
WHERE laenge_minuten > 120;
```


**h. Alle Filme, die von Tarantino oder Spielberg gedreht wurden**
```sql
SELECT * FROM dvd_sammlung
WHERE regisseur = 'Quentin Tarantino'
   OR regisseur = 'Steven Spielberg';
```


**i. Filme von Tarantino, die kürzer als 90 Minuten sind**
```sql
SELECT * FROM dvd_sammlung
WHERE regisseur = 'Quentin Tarantino'
  AND laenge_minuten < 90;
```


**j. Film mit „Sibirien“ im Titel**
```sql
SELECT * FROM dvd_sammlung
WHERE film LIKE '%Sibirien%';
```


**k. Alle Teile von „Das große Rennen“**
```sql
SELECT * FROM dvd_sammlung
WHERE film LIKE 'Das große Rennen%';
```


**l. Alle Filme sortiert nach Regisseur**
```sql
SELECT * FROM dvd_sammlung
ORDER BY regisseur;
```


**m. Alle Filme sortiert nach Regisseur, dann Filmtitel**
```sql
SELECT * FROM dvd_sammlung
ORDER BY regisseur, film;
```


**n. Alle Filme von Tarantino, längste zuerst**
```sql
SELECT * FROM dvd_sammlung
WHERE regisseur = 'Quentin Tarantino'
ORDER BY laenge_minuten DESC;
```



## Checkpoint Fragen (für Lernportfolio)

**Welche Schwierigkeiten beim Einfügen von Daten ergeben sich, wenn z.B. der FK_Vorgesetzter als Constraint definiert ist?**(Tipp: Referentielle Integrität)

- referenzielle Integrität bedeutet: der Wert im Fremdschlüssel-Feld (z. B. FK_Vorgesetzter) muss auf einen gültigen Primärschlüsselwert in der referenzierten Tabelle zeigen

Schwierigkeit beim Einfügen:
- Man kann einen Mitarbeiterdatensatz mit einem FK_Vorgesetzter nur einfügen, wenn der referenzierte Vorgesetzte bereits existiert.

Beispielproblem:
- Man möchte gleichzeitig Chef und Mitarbeiter in einem Rutsch einfügen, aber der Chef-Datensatz existiert noch nicht → Insert schlägt fehl.

→ Typischer Lösungsansatz: Erst den Vorgesetzten-Datensatz anlegen, dann die Mitarbeiter-Datensätze mit gültigem FK.



**Warum ist der Wert NULL in der tbl_Hierarchie nicht zulässig?** (Tipp: Kardinalität)
- Wenn die Kardinalität 1:1 oder 1:n verlangt, dass jeder Datensatz zwingend einen gültigen Verweis auf den übergeordneten Knoten hat, darf FK_Vorgesetzter nicht NULL sein
- NULL bedeutet: „kein Vorgesetzter“ (also keine Beziehung).
→ In einer echten Hierarchie-Struktur ohne NULL-Zulassung ist jeder Mitarbeiter Teil einer lückenlosen Kette → jeder muss einen Chef haben
- Aber: Oft wird für die oberste Hierarchie-Ebene (CEO) NULL zugelassen, um die Wurzel der Hierarchie darzustellen.

**Wann muss eine Hierarchie-Tabelle anstelle einer rekursiven Beziehung eingesetzt werden?** (Tipp: Chefs)
- Eine rekursive Beziehung (FK verweist auf dieselbe Tabelle) funktioniert gut für einfache Hierarchien, wo jeder Mitarbeiter genau einen Vorgesetzten hat
- Eine separate Hierarchie-Tabelle wird gebraucht, wenn:
  - Es mehrere Chefs pro Mitarbeiter geben kann (n:m-Beziehung)
  - Man Rollen/Beziehungen zwischen Chef und Mitarbeiter zusätzlich modellieren will (z. B. „Fachvorgesetzter“, „Disziplinarvorgesetzter“)
  - Die Hierarchien komplexer sind, z. B. projektbezogene Mehrfachzuordnungen.

Beispiel:
- Tabelle Mitarbeiter (einfach) → rekursiv FK_Vorgesetzter
- Tabelle Hierarchie (n:m): MitarbeiterID, VorgesetzterID → erlaubt mehrere Zuweisungen.


**Überprüfen Sie ihre SQL-Datentypen-Tabelle: Check Präsentation**
(Anleitung statt fertige Antwort, weil das individuell ist)

Prüfen:
- Welche Datentypen habe ich in meinen Tabellen definiert?
- Stimmen sie mit der Präsentation überein?
- INT, BIGINT für IDs?
- VARCHAR(…) für Namen?
- DATE oder DATETIME für Zeitangaben?
- DECIMAL/NUMERIC für Geldbeträge?
- Sind die Längen sinnvoll gewählt?
- Habe ich unnötig restriktive oder zu breite Typen?
- Passen die Typen zu meinem DBMS (MySQL, MariaDB, etc.)?

