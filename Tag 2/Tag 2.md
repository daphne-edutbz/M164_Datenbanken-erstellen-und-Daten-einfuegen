# Lernportfolio Modul 164 – Tag 2
- **Name:** Daphne Sibel McNamara
- **Klasse:** AP 24b
- **Modul:** 164 – Datenbanken erstellen und Daten einfügen  
- **Datum:** 20.05.2025
- - Miro-Board: https://miro.com/app/board/uXjVI29IW6Y=/


---


## Lernziele für Tag 2
- **Generalisierung / Spezialisierung** verstehen und anwenden  
- Identifying und Non-Identifying Relationships unterscheiden können  
- Praktisches Beispiel in SQL umsetzen  
- Datenbank mit DDL erstellen  
- Forward Engineering nutzen (mit MySQL Workbench)

## Gelerntes (LEARN)

### Generalisierung / Spezialisierung
- Bei mehreren Entitätstypen mit **vielen gemeinsamen Attributen** (z. B. Name, Adresse, Geburtsdatum) entstehen Redundanzen, wenn diese Informationen mehrfach gespeichert werden.
- Beispiel: `Mitarbeiter`, `Kunde`, `Fahrer` – alle haben Name & Adresse. Doppelte Speicherung führt zu **Dateninkonsistenz**.


#### Generalisierung
- Gemeinsamkeiten werden in eine **übergeordnete Entität** verschoben.
- z. B.: `Person` als Oberklasse für `Fahrer` und `Disponent`.
- Vorteil: Gemeinsame Attribute nur **einmal speichern**.

#### Spezialisierung
- Spezifische Attribute (z. B. `Führerscheinklasse`) bleiben im **untergeordneten Entitätstyp**.
- Jede Spezialisierung verweist via **Fremdschlüssel** auf die übergeordnete Entität.
- Beziehung = `is_a` → `Fahrer is_a Person`.

Dadurch vermeiden wir **Redundanz** und **Inkonsistenz** in den Datenbanken.

#### Beispiel Generalisierung:

```sql
CREATE TABLE Person (
    Person_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Adress VARCHAR(255)
);

CREATE TABLE Driver (
    Driver_ID INT PRIMARY KEY,
    Licence VARCHAR(20),
    Person_ID INT,
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);

CREATE TABLE Dispatcher (
    Dispatcher_ID INT PRIMARY KEY,
    Experience INT,
    person_id INT,
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);
```
#### Beispiel Spezialisierung:

![image](https://github.com/user-attachments/assets/351fd3e7-17cb-4df0-b4f1-59f1b7fce8ef) 




## Beziehungsarten

In relationalen Datenbanken unterscheidet man zwei wichtige Arten von Beziehungen zwischen Tabellen: **Identifying** und **Non-Identifying Relationships**.

### Struktur 
- **Parent-Tabelle** (Master) und eine **Child-Tabelle** (Detail)
- **Primary Key** der Parent-Tabelle wird in der Child-Tabelle als **Foreign Key** verwendet
- Entscheidend ist, **ob dieser Foreign Key Teil des Primary Keys der Child-Tabelle ist**


![image (1)](https://github.com/user-attachments/assets/ff6df42e-ac5d-4761-9aa4-993c7f772698)


### Identifying Relationship
- Foreign Key ist **Teil des Primary Keys** der Child-Tabelle
- Datensatz in der Child-Tabelle **kann ohne den Parent-Datensatz nicht existieren**.
- Identität des Child-Datensatzes ist **abhängig** von der Parent-Tabelle.
- Beziehung ist **essentiell** für die Identifikation.

**Beispiel**:  
Ein **Ausweis** gehört eindeutig zu einer **Person**. Ohne die Person ergibt der Ausweis keinen Sinn.  
→ Der Fremdschlüssel (Personen-ID) ist Teil des Primärschlüssels in der Ausweis-Tabelle.


### Non-Identifying Relationship
- Der Foreign Key ist **nicht** Teil des Primary Keys der Child-Tabelle
- Der Child-Datensatz **existiert unabhängig** von der Parent-Tabelle
- Beziehung ist **optionaler Kontext**, aber **nicht entscheidend für die Identität**

**Beispiel**:  
**Kleidungsstücke** gehören zwar zu einer **Person**, aber jedes Kleidungsstück hat seine eigene ID und kann auch ohne diese Person verwaltet werden.  
→ Fremdschlüssel existiert, aber ist **nicht Teil des Primärschlüssels**.


![image (2)](https://github.com/user-attachments/assets/b1a84c99-2ea1-471a-ab3d-1da0764737c0)


### Eigene Beispiele

### Beispiel für eine **Identifying Relationship**:
- **Gebäude – Raum**  
Ein Raum existiert nur im Kontext eines Gebäudes.  
→ Die Raum-ID enthält die Gebäude-ID.

### Beispiele aus der Klasse:
- **Projekt – Aufgabe**  
- **Kurs – Modul**  
- **Reisebuchung – Flugabschnitt**  
- **Bestellung – Position**  
- **Bibliothek – Regal – Buch**  
- **Lernplattform – Kurs – Inhaltsmodul**


### KI-recherchierte Anwendungsfälle für Identifying Relationships

**Bestellwesen**  
- Bestellung enthält Positionen.  
- Die Bestellposition ist ohne Bestellung bedeutungslos.

**Reisebuchungssystem**  
- Hauptbuchung besteht aus Teilbuchungen (Hotel, Flug, etc.).  
- Teilbuchungen hängen direkt an der Hauptbuchung.

**Produktion**  
- Produkt besteht aus Bauteilen.  
- Bauteile existieren nur im Zusammenhang mit dem Produkt.

**Lernplattform**  
- Kurs enthält Module.  
- Modul ist nur im Kontext des Kurses sinnvoll.

![image (3)](https://github.com/user-attachments/assets/2a99676e-691f-49c0-84d1-02e2fb00b570)




## DBMS (Datenbankmanagementsystem)

 **Datenbanksystem (DBS)**: System zur elektronischen Verwaltung grosser Datenmengen. 

 
Besteht aus:
- **DBMS** (Software zur Verwaltung der Daten)  
   **Datenbank (DB)** (die eigentlichen Daten)

**Aufgaben:**  
- Daten dauerhaft, effizient und widerspruchsfrei speichern  
- Zugriff auf Daten durch Benutzer und Programme ermöglichen  
- Verwaltung komplexer Beziehungen zwischen Daten  
- Bereitstellung von Datenbanksprache (SQL)  
- Sicherheit, Konsistenz und Mehrbenutzerfähigkeit gewährleisten

**Funktionen eines DBMS:**
- Integrierte Datenhaltung: Daten werden einheitlich und möglichst redundantfrei gespeichert  
- Datenbanksprache (SQL):  
  - DQL (Data Query Language): z.B. `SELECT`  
  - DDL (Data Definition Language): z.B. `CREATE`, `ALTER`  
  - DML (Data Manipulation Language): z.B. `INSERT`, `UPDATE`  
  - DCL (Data Control Language): z.B. `GRANT`, `REVOKE`  
  - TCL (Transaction Control Language): z.B. `COMMIT`, `ROLLBACK`  
- Katalog (Data Dictionary): Metadatenverwaltung  
- Benutzersichten (Views): Unterschiedliche Datenansichten für Benutzer  
- Konsistenzkontrolle: Integritätsbedingungen (Constraints)  
- Datenzugriffskontrolle: Zugriffsbeschränkungen und Berechtigungen  
- Transaktionen: Atomare, dauerhafte Einheiten von Datenänderungen  
- Mehrbenutzerfähigkeit: Synchronisation bei gleichzeitigen Zugriffen  
- Datensicherung und Recovery

**Vorteile eines DBMS:**
- Nutzung von Standards und Fachbegriffen  
- Effizienter Datenzugriff und -speicherung  
- Schnellere Softwareentwicklung durch Abstraktion  
- Hohe Flexibilität (Datenunabhängigkeit)  
- Hohe Verfügbarkeit (gleichzeitiger Zugriff)  
- Wirtschaftlichkeit durch Zentralisierung

**Nachteile:**
- Hohe Anfangsinvestitionen  
- Komplexität und benötigtes Spezialwissen  
- Überdimensionierung bei kleinen oder einfachen Anwendungen  
- Zentralisierung kann auch Risiken mit sich bringen


## DB-Engine-Produkte

| Produkt        | Hersteller       | Modell / Charakteristik            |
|----------------|------------------|----------------------------------|
| Adabas         | Software AG      | NF2-Modell (nicht normalisiert)  |
| Cache          | InterSystems     | hierarchisch, „postrelational“   |
| DB2            | IBM              | objektrelational                 |
| Firebird       | –                | relational (basierend auf InterBase) |
| IMS            | IBM              | hierarchisch, Mainframe          |
| Informix       | IBM              | objektrelational                 |
| InterBase      | Borland          | relational                      |
| MS Access      | Microsoft        | relational, Desktop-System       |
| MS SQL Server  | Microsoft        | objektrelational                 |
| MySQL          | MySQL AB         | relational                      |
| Oracle         | ORACLE           | objektrelational                 |
| PostgreSQL     | –                | objektrelational                 |
| Sybase ASE     | Sybase           | relational                      |
| Versant        | Versant          | objektorientiert                |
| Visual FoxPro  | Microsoft        | relational, Desktop-System       |
| Teradata       | NCR Teradata     | relationales Hochleistungs-DBMS |

### DB-Engine-Produkte Mindmap

**Top 10 DB-Engines (Mai 2025):**

1. Oracle
  - Modell: Relational, Multi-model
  - Sehr etabliert in Unternehmen
2. MySQL
  - Modell: Relational, Multi-model
  - Open Source, weit verbreitet
3. Microsoft SQL Server
  - Modell: Relational, Multi-model
  - Gute Integration in Microsoft-Ökosystem
4. PostgreSQL
  - Modell: Relational, Multi-model
  - Open Source, sehr flexibel
5. MongoDB
  - Modell: Document, Multi-model
  - Dokumentenorientiert, JSON-ähnliche Speicherung
6. Snowflake
  - Modell: Relational
  - Cloud-native Data Warehouse-Lösung
7. Redis
  - Modell: Key-value, Multi-model
  - In-Memory DB, sehr schnell
8. IBM Db2
  - Modell: Relational, Multi-model
  - Unternehmenslösung von IBM
9. Elasticsearch
  - Modell: Multi-model (Suchmaschine, NoSQL)
  - Besonders für Volltextsuche und Logs
10. SQLite
  - Modell: Relational
  - Leichtgewichtig, für mobile und eingebettete Systeme




## DDL – Anlegen einer Datenbank (Repetition ÜK Modul 106)

**Schema = Datenbank (MySQL-Synonym)**

Ein DBS enthält mehrere Schemas (Datenbanken), die wiederum mehrere Tabellen beinhalten.

### SQL-Aufgaben

1. **CREATE SCHEMA / CREATE TABLE**  
   Erstelle zwei Tabellen mit SQL, verwende `utf8mb4` als Default Charset.

2. **DROP TABLE**  
   Lösche eine Tabelle und stelle sie mit dem Script wieder her.

3. **Tabelle tbl_Mitarbeiter erstellen** mit folgenden Attributen:

| Attribut     | Datentyp         |
|--------------|------------------|
| MA_ID        | INT              |
| Name         | VARCHAR(50)      |
| Vorname      | VARCHAR(30)      |
| Geburtsdatum | DATETIME         |
| Telefonnummer| VARCHAR(12)      |
| Einkommen    | FLOAT(10,2)      |

4. **ALTER TABLE**  
   - Ändere Charset von `Name` und `Vorname` auf `latin1`.  
   - Lösche aus `tbl_fahrer` und `tbl_disponent` die Attribute `Name`, `Vorname` und `Telefonnummer`.  
   - Füge Fremdschlüssel für Spezialisierungen hinzu.

5. **SQL-Scripte** bitte im Lernportfolio ablegen

![Uploading DDL-Aufgabe.sql…]()

```sql

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
```



## Forward Engineering mit MySQL Workbench

**Forward Engineering:** wandelt Datenmodell (ERD) in ein SQL-Script um, das die Datenbankstruktur erzeugt.

### Ablauf:
- Erstelle ein Modell mit Tabellen und Relationen (z.B. Tourenplaner).  
- Generiere SQL-Statements via Database > Forward Engineer...  
- Speichere das Script als Vorlage im Lernportfolio.  
- Verbinde dich mit DB-Server und lade die Struktur hoch.  
- Untersuche Struktur und SQL-Script auf neue Befehle.  
- Erstelle Eintrag im Lernportfolio.

### Synchronize Modell
- Vergleiche Modell mit existierender Datenbank.  
- Füge neue Tabellen/Attribute hinzu und synchronisiere.


## Non-Identifying / Identifying Relationships – Übung

Erstelle ein neues Modell mit den Tabellen:

- `Person`  
- `Kleidungsstück` (Non-Identifying Relationship)  
- `Ausweis` (Identifying Relationship)

Person Table (Eltern Tabelle)

```sql
CREATE TABLE Person (
    person_id INT PRIMARY KEY,
    name VARCHAR(50)
);
```


Kleidungsstück Table
```sql
-- Non-Identifying Relationship:
-- Die Beziehung zu Person besteht über einen Fremdschlüssel,
-- aber die Primärschlüssel der Tabellen bleiben unabhängig.
CREATE TABLE Kleidungsstueck (
    kleid_id INT PRIMARY KEY,
    typ VARCHAR(50),
    person_id INT,
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);
```
- Bei der Non-Identifying Relationship bleibt kleid_id der alleinige Primärschlüssel
- person_id ist nur ein Fremdschlüssel (Kleidungsstück kann unabhängig identifiziert werden, "gehört"  einer Person, ist aber nicht von ihr zum Identifizieren abhängig)

Ausweis Table
```sql
-- Identifying Relationship:
-- Die Identität des Ausweises ist direkt von der zugehörigen Person abhängig.
-- Der Primärschlüssel ist ein zusammengesetzter Schlüssel (Composite Key).
CREATE TABLE Ausweis (
    person_id INT,
    ausweis_nr VARCHAR(20),
    PRIMARY KEY (person_id, ausweis_nr),
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);
```
- Bei der Identifying Relationship ist person_id Teil des Primärschlüssels (weil Ausweis ohne zugehörige Person nicht eindeutig identifiziert werden kann)
- Ausweis ist also "kind" in einer stark abhängigen Beziehung (Identifying)


Generiere via Forward Engineering das SQL-Script und untersuche den Unterschied bei den `PRIMARY KEY`-Definitionen.

```sql
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `Person`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Person` ;

CREATE TABLE IF NOT EXISTS `Person` (
  `idPerson` INT NOT NULL,
  `name` VARCHAR(50) NULL,
  PRIMARY KEY (`idPerson`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Kleidungsstück`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Kleidungsstück` ;

CREATE TABLE IF NOT EXISTS `Kleidungsstück` (
  `Kleidungsstück_id` INT NOT NULL,
  `typ` VARCHAR(50) NULL,
  `Person_idPerson` INT NOT NULL,
  PRIMARY KEY (`Kleidungsstück_id`),
  INDEX `fk_Kleidungsstück_Person_idx` (`Person_idPerson` ASC) VISIBLE,
  CONSTRAINT `fk_Kleidungsstück_Person`
    FOREIGN KEY (`Person_idPerson`)
    REFERENCES `Person` (`idPerson`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Ausweis`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Ausweis` ;

CREATE TABLE IF NOT EXISTS `Ausweis` (
  `Person_idPerson` INT NOT NULL,
  `Ausweis_id` INT NOT NULL,
  PRIMARY KEY (`Person_idPerson`, `Ausweis_id`),
  INDEX `fk_Ausweis_Person1_idx` (`Person_idPerson` ASC) VISIBLE,
  CONSTRAINT `fk_Ausweis_Person1`
    FOREIGN KEY (`Person_idPerson`)
    REFERENCES `Person` (`idPerson`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;




SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
```





## Fortgeschrittene Recherche-Aufgabe

### Partition (Datenbanken)
**Definition:** Grosse Tabellen in einer Datenbank werden logisch oder physisch in kleinere Einheiten (Partitionen) aufgeteilt. 


**Ziele:**
- Bessere Performance
- Verwaltbarkeit & Skalierbarkeit
- Leistungssteigerung (Abfragen betreffen oft nur eine oder wenige Partitionen (schnellerer Zugriff))
- Einfachere Wartung (lassen sich getrennt archivieren, löschen oder sichern)
- Parallelisierung (Verschiedene Partitionen können gleichzeitig bearbeitet werden)
- Bessere Speicherverwaltung (Verteilung über verschiedene Speichergeräte möglich)

**Arten von Partitionierung**
| Typ                  | Beschreibung                                                                 |
|----------------------|------------------------------------------------------------------------------|
| Range Partitioning   | Nach Wertebereichen – z. B. nach Datum: 2020–2022, 2023–2024 usw.             |
| List Partitioning    | Nach festen Werten – z. B. Land: ('DE', 'AT'), ('US'), ('FR') etc.           |
| Hash Partitioning    | Zufällige Verteilung basierend auf Hash-Werten eines Attributs (z. B. ID).   |
| Composite (Sub-)     | Kombination, z. B. Range + Hash                                              |


**Vorteile:**
- Schnellere Queries bei grossen Datenmengen
- Bessere Backup-/Restore-Kontrolle
- Skalierbarkeit für Big Data

**Nachteile:**
- Höhere Komplexität beim Design
- Kann falsche Partitionierung zu schlechterer Performance führen
- Einschränkungen bei einigen SQL-Operationen


**Hinweise:**
- Nicht alle DBMS unterstützen Partitionierung gleich gut (MySQL, PostgreSQL, Oracle, SQL Server etc.)
- Partitionierung ist transparent für viele SQL-Befehle, aber nicht alle Funktionen sind in Partitionen erlaubt (z. B. FOREIGN KEY-Constraints bei MySQL).


Beispiel (MySQL)
```sql
CREATE TABLE Verkäufe (
  id INT,
  jahr INT
)
PARTITION BY RANGE (jahr) (
  PARTITION p1 VALUES LESS THAN (2022),
  PARTITION p2 VALUES LESS THAN (2024)
);

```

### Storage Engine (Speicher-Engine) (Datenbanken)  

**Definition:** Komponente eines Datenbanksystems, die für das Speichern, Abrufen und Verwalten von Daten auf physikalischer Ebene verantwortlich ist. Sie bestimmt, wie Daten gespeichert werden, wie Transaktionen verarbeitet werden und ob z. B. Referenzielle Integrität unterstützt wird.

**Funktionen:**
- Datenspeicherung & -abruf
- Transaktionsverarbeitung (ACID)
- Locking-Mechanismen (z. B. row vs. table locking)
- Indexierung
- Replikation & Backup-Unterstützung

**Beispiele:**
| Storage Engine | Eigenschaften                                                                   |
|----------------|----------------------------------------------------------------------------------|
| **InnoDB**     | Standard in MySQL. Unterstützt Transaktionen, Row-Level Locking, FK-Beziehungen |
| **MyISAM**     | Schneller bei Lesezugriffen, keine Transaktionen, Table-Locking                 |
| **Memory**     | Daten im RAM gespeichert, sehr schnell, flüchtig (verlustbehaftet bei Neustart) |
| **CSV**        | Speichert Daten in CSV-Dateien, gut für Export/Import                           |
| **Archive**    | Für grosse, schreibintensive Daten – keine Indexe, komprimiert                   |
| **Federated**  | Greift auf entfernte MySQL-Server zu (verteilte Datenbank)                      |

- Transaktionssicherheit benötigt → InnoDB
- Hoher Lesezugriff, keine Transaktionen → MyISAM
- Temporäre Daten → Memory Engine
- Verteilte Systeme → Federated Engine


### Tablespace (InnoDB), inklusive Diagramm zur Tablespace-Architektur

**Definition:** In MySQL (InnoDB) ist ein Tablespace der Speicherbereich, in dem Datenbankobjekte wie Tabellen und Indizes physisch gespeichert werden. InnoDB verwendet ein Tablespace-Modell, um Daten effizient zu organisieren, zu verwalten und performant zu speichern.

**Arten:**
| Tablespace-Typ                | Beschreibung                                                                                        |
| ----------------------------- | --------------------------------------------------------------------------------------------------- |
| **System Tablespace**         | Standardmässiger, gemeinsamer Speicherbereich (`ibdata1`), enthält Metadaten, Undo, ggf. auch Daten. |
| **File-Per-Table Tablespace** | Separater Tablespace pro Tabelle (`.ibd`-Dateien). Aktiv durch `innodb_file_per_table=ON`.          |
| **Undo Tablespace**           | Speichert Undo-Logs (für Rollback, MVCC). In neueren Versionen (ab MySQL 8) ausgelagert.            |
| **General Tablespace**        | Benutzerdefinierter, gemeinsam genutzter Speicherbereich für mehrere Tabellen.                      |
| **Temporary Tablespace**      | Für temporäre Tabellen und Operationen wie Sortierung und Joins. Automatisch verwaltet.             |





## Checkpoint Fragen (für Lernportfolio)


### Warum macht man Generalisierung/Spezialisierung?

Man verwendet **Generalisierung/Spezialisierung**, um **Redundanz** und **Inkonsistenz** in Datenbanken zu vermeiden:

- **Generalisierung**:  
  Fasst gemeinsame Attribute mehrerer Entitätstypen in einer übergeordneten Entität (z. B. `Person`) zusammen. Dadurch werden doppelte Daten vermieden.

- **Spezialisierung**:  
  Spezifische Eigenschaften werden in untergeordneten Entitäten (z. B. `Fahrer`, `Disponent`) gespeichert. Diese sind über einen **Fremdschlüssel** mit der übergeordneten Entität verbunden.

### Warum und wie erstellt man Identifying Relationships in SQL?

#### Warum?

**Identifying Relationships** werden eingesetzt, wenn ein Datensatz in der Child-Tabelle **nicht unabhängig** von einem Datensatz in der Parent-Tabelle existieren kann.

**Beispiel**:  
Ein `Ausweis` existiert nur in Verbindung mit einer `Person`. Ohne die zugehörige `Person` hat der `Ausweis` keine eigenständige Bedeutung.

#### Wie?

Man erstellt eine Identifying Relationship, indem man den **Fremdschlüssel** auch als **Teil des Primärschlüssels** in der Child-Tabelle definiert:

```sql
CREATE TABLE Ausweis (
    person_id INT,
    ausweis_nr VARCHAR(20),
    PRIMARY KEY (person_id, ausweis_nr),
    FOREIGN KEY (person_id) REFERENCES Person(person_id)
);
```

Merkmale: 
- person_id ist Teil des Primary Keys in der Tabelle Ausweis
- Die Identität des Ausweises hängt direkt von der Person ab


### Welche SQL-Befehle gehören zur DDL-Gruppe?

DDL (Data Definition Language) dient der Strukturerstellung und -verwaltung in Datenbanken. Zu den wichtigsten DDL-Befehlen gehören:
- CREATE – erstellt Datenbanken, Tabellen oder andere Objekte
- ALTER – verändert bestehende Strukturen (z. B. Spalten hinzufügen, Datentypen ändern)
- DROP – löscht Objekte aus der Datenbank
- TRUNCATE – leert Tabelleninhalte schnell, ohne Struktur zu löschen
Diese Befehle definieren wie die Daten gespeichert werden, nicht was gespeichert wird.
