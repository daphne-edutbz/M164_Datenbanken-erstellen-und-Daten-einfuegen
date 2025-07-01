# Lernportfolio Modul 164 – Tag 7
- **Name:** Daphne Sibel McNamara
- **Klasse:** AP 24b
- **Modul:** 164 – Datenbanken erstellen und Daten einfügen  
- **Datum:** 24.06.2025

---

## Lernziele für Tag 7
- Verstehen, warum Backups notwendig sind
- Backup-Konzepte kennen
- Arten von Backups unterscheiden können
- Backup-Strategien planen
- Konkrete Tools und Methoden für Datenbanksicherung anwenden können
- Backup-User einrichten können
- Restore-Prozesse verstehen
- Sicherstellen von Datensicherheit und -integrität


## Datenbank-Backup

### Warum Backups?
- Schutz vor Datenverlust (Hardwarefehler, Benutzerfehler, Softwarefehler)
- Reduziert Ausfallzeiten
- Kritisch für Unternehmensprozesse und Kundenzufriedenheit
- Verhindert Vertrauensverlust bei Datenverlust

**Häufige Ursachen:**
- Hardware-Defekte
- Benutzerfehler
- Softwareprobleme
- Angriffe (selten, aber möglich)

### Backup-Konzepte

**Online- vs. Offline-Backup**
- Online-Backup: DB bleibt verfügbar, Änderungen werden zwischengespeichert
- Offline-Backup: DB wird gestoppt, einfacher, aber Downtime nötig

### Backup-Typen
- **Voll-Backup**
  - Sichert gesamte Datenbank
  - Restore benötigt nur dieses Backup
  - Nachteil: hoher Speicherbedarf

- **Differentielles Backup**
  - Sichert alle Änderungen seit letztem Voll-Backup
  - Restore benötigt Voll-Backup + dieses Backup
  - Vorteil: spart Speicherplatz

- **Inkrementelles Backup**
  - Sichert nur Änderungen seit letztem Backup (voll oder inkrementell)
  - Restore benötigt Voll-Backup + alle Inkremente
  - Vorteil: sehr platzsparend


### Tools für Datenbank-Backup

| Tool         | Beschreibung                                                         |
|--------------|----------------------------------------------------------------------|
| `mysqldump`  | CLI-Tool für logische SQL-Dumps, einfach und weit verbreitet         |
| phpMyAdmin   | Web-GUI, beschränkt bei grossen Datenbanken (>2MB Upload-Limit)       |
| BigDump      | Tool für den Import grosser SQL-Dumps, kein Backup-Tool selbst        |
| HeidiSQL     | Windows-GUI ohne PHP-Limitierung, manuell bedienbar                  |
| Mariabackup  | CLI-Tool für physische Backups (InnoDB), unterstützt Online-Backups  |


### Backup-Strategie
- Häufigkeit an Datenänderungsrate anpassen
- Offsite/Offline speichern (z. B. andere Rechenzentren)
- Verschlüsselung gegen Diebstahl
- Restore-Tests regelmässig durchführen


### Beispiel: Backup-User einrichten
```sql
GRANT RELOAD, PROCESS, LOCK TABLES, REPLICATION CLIENT
ON *.*
TO 'backupuser'@'localhost'
IDENTIFIED BY 'backup123';
```

### Grundlegender Ablauf: Daten in eine normalisierte DB bringen
1. Analyse der Quelldaten
  1. NF: atomare Felder
  2. NF: funktionale Abhängigkeiten entfernen
  3. NF: transitive Abhängigkeiten entfernen
2. ER-Modell (logisch → physisch) erstellen
3. Tabellenstruktur mit Constraints umsetzen
4. Daten importieren und testen
5. Redundanzen und Inkonsistenzen bereinigen



## Auftrag Datensicherung
In diesem Auftrag erstellen wir ein logisches Datenbank-Backup der Datenbank tourenplaner mit dem Tool mysqldump. Die Installation erfolgte mit MariaDB/XAMPP auf Windows. Es werden verschiedene Methoden zum Backup und Restore besprochen und praktisch angewendet.


### Aufgabe 1: Logisches Backup mit mysqldump
**Vorgehen:**

 1. MySQL/MariaDB starten
```
C:\xampp\mysql\bin\mysql.exe -u root -p
```
Nach Eingabe des Passworts gelangt man in die MariaDB-Shell.

 2. Datenbank und Tabellen anlegen 

 3. Testdaten einfügen
```sql
INSERT INTO touren (name, startort, zielort, datum) VALUES
('Sommer Tour', 'Bern', 'Genf', '2025-07-10'),
('Winter Tour', 'Zürich', 'St. Moritz', '2025-12-15');

INSERT INTO mitarbeiter (vorname, nachname, rolle) VALUES
('Anna', 'Müller', 'Fahrer'),
('Peter', 'Schmidt', 'Tourguide');
```

4. Backup mit `mysqldump` erzeugen

```C:\xampp\mysql\bin\mysqldump.exe -u root -p --databases tourenplaner > C:\Backup\tourenplaner_dump.sql```
- Passwort eingeben
- Backup-Datei wird im angegebenen Pfad erstellt

5. Datenbank löschen und Backup einspielen (Restore)

```sql
DROP DATABASE IF EXISTS tourenplaner;
CREATE DATABASE tourenplaner;
USE tourenplaner;
source C:/Backup/tourenplaner_dump.sql;
```
- Restore der Datenbank aus dem Backup-File


6. Erfolg prüfen
```sql
SHOW TABLES;
SELECT * FROM touren;
SELECT * FROM mitarbeiter;
```
- Alle Daten und Tabellen sind wiederhergestellt.


### Aufgabe 2: Backup-File analysieren und verifizieren
- Dumpfile enthält DDL-Befehle (CREATE DATABASE, CREATE TABLE) und DML-Befehle (INSERT INTO), die zum Wiederherstellen der Datenbankstruktur und Daten notwendig sind.
- Backup ist logisch: Es sichert SQL-Anweisungen und keinen rohen Datenbankzustand.
- Restore funktioniert einwandfrei, wenn die Datenbank vor dem Einlesen entweder neu angelegt oder gelöscht wurde.

### Aufgabe 3: Backup-Strategien
**a) Welches Backup wurde erstellt?**
- logisches Backup mittels mysqldump, das SQL-Skripte mit Struktur und Daten enthält

**b) Nachteile dieses Backups:**
- Restore kann zeitintensiv sein bei grossen Datenmengen
- Backup ist grösser als ein physisches Backup
- Keine direkte Sicherung des exakten physischen Datenbankzustands
- Kann im laufenden Betrieb inkonsistente Daten sichern (wenn nicht konsistent gesperrt)

**Online vs. Offline Backup:**
- Online: Backup während der Datenbank läuft (z.B. mysqldump)
- Offline: Backup bei abgeschaltetem Datenbankserver (physische Dateikopie)

**Snapshot Backup:**
Ein schnelles Backup des gesamten Dateisystems oder der Datenbankdateien zu einem Zeitpunkt, z.B. mit Filesystem-Snapshots oder speziellen Tools, meist sehr schnell und konsistent.


### Aufgabe 4: Physisches Backup (MariaDB, XAMPP)
- Mit mariabackup.exe kann ein physisches Backup der Datenbank erstellt werden, indem die Datenbankdateien direkt gesichert werden.
- Vor einem Restore muss das Backup mit dem Parameter --prepare vorbereitet werden, um Transaktionen zu finalisieren.
- Restore erfolgt über das Kopieren der gesicherten Dateien zurück in das Datenverzeichnis.
- Inkrementelle und differentielle Backups sind möglich und helfen, Speicherplatz zu sparen.


### Aufgabe 5: Backup mit externem Programm
- Beispiel: Backup und Restore mit Acronis, einem professionellen Backup-Tool, das auch systemweite und Dateisystem-Backups erlaubt.
- Externe Programme sichern auch Datenbankdateien und bieten oft mehr Automatisierung und Wiederherstellungsoptionen.



### Checkpoint-Fragen
**Unterschied logisches vs. physisches Backup**

- Logisches Backup: Export in SQL-Script (DDL + DML). Beispiel: `mysqldump`
- Physisches Backup: Kopie der Datenbankdateien auf Block-Ebene. Beispiel: `mariabackup`

**Restore-Prozess der Backup-Typen**
- FULL: Ein File wiederherstellen → sofort nutzbar
- INKREMENTELL: Voll-Backup einspielen + alle inkrementellen Backups der Reihe nach
- DIFFERENZIELL: Voll-Backup einspielen + letztes differentielles Backup


**Drei Möglichkeiten für Backups**
- mysqldump
Shell-Befehl:
```bash
mysqldump -u root -p datenbank > backup.sql
```
- phpMyAdmin
GUI → Export → SQL
- Mariabackup
CLI → physische Kopie inkl. Prepare-Phase


**Fünf Schritte zur 3. Normalform**
1. 1NF: nur atomare Werte
2. Identifizieren des Primärschlüssels
3. 2NF: alle Nichtschlüsselattribute voll funktional abhängig vom PK
4. 3NF: keine transitiven Abhängigkeiten
5. Definition der Fremdschlüssel


**Was macht `SELECT INTO OUTFILE`?**
Exportiert Ergebnisse einer SELECT-Abfrage direkt in eine Datei auf dem Server:
```sql
SELECT * FROM tabelle INTO OUTFILE 'C:/Pfad/ausgabe.csv';
```



