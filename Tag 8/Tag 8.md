# Lernportfolio Modul 164 – Tag 8
- **Name:** Daphne Sibel McNamara
- **Klasse:** AP 24b
- **Modul:** 164 – Datenbanken erstellen und Daten einfügen  
- **Datum:** 01.07.2025
- Miro-Board: https://miro.com/app/board/uXjVI29IW6Y=/

---

## Aufgabe: Daten normalisiert einbinden - Aufgabe DB_Freifaecher nochmals ...

1. Erste Normalform (1NF) aus Excel

- schüler.csv
- Freifaecher.csv
- FK Klasse.csv
- FK Klassenlehrerin.csv
- FK_TT_FF_Schülerln.csv
- Freifächer (Auszug).csv


2. Logisches ERD (2NF)
Ich habe aus der 1NF die Tabellen in die 2. Normalform gebracht. Abhängigkeiten von Teil-Schlüsseln wurden entfernt. Redundanz wurde eliminiert.
  
Tabellen (mindestens 5):
- SCHUELER (PK_SchuelerID, Vorname, Nachname, Geburtsdatum, FK_KlassenID)
- KLASSE (PK_KlassenID, Bezeichnung)
- FREIFACH (PK_FreifachID, Bezeichnung)
- LEHRER (PK_LehrerID, Vorname, Nachname)
- ANMELDUNG (PK_AnmeldungID, FK_SchuelerID, FK_FreifachID, FK_LehrerID)


3. Physisches ERD
Ich habe die Tabellen mit allen Attributen in MySQL Workbench modelliert. Dabei habe ich:
- NOT NULL und UNIQUE Constraints gesetzt (z. B. Namen eindeutig, IDs PK)
- Foreign Keys mit ON DELETE RESTRICT/SET NULL
- Datentypen festgelegt (z. B. INT, VARCHAR(50), DATE)

Beispiel SQL-DDL-Script:
```sql
CREATE TABLE IF NOT EXISTS KLASSE (
    KlassenID INT PRIMARY KEY AUTO_INCREMENT,
    Bezeichnung VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS SCHUELER (
    SchuelerID INT PRIMARY KEY AUTO_INCREMENT,
    Vorname VARCHAR(50) NOT NULL,
    Nachname VARCHAR(50) NOT NULL,
    Geburtsdatum DATE,
    KlassenID INT,
    FOREIGN KEY (KlassenID) REFERENCES KLASSE(KlassenID)
);
```

4. Datenimport
Ich habe die CSV-Dateien bereinigt und mit `LOAD DATA LOCAL INFILE` in die Tabellen geladen. Dabei habe ich Spalten und Trennzeichen kontrolliert.


Beispiel-Befehl:
```sql
LOAD DATA LOCAL INFILE 'schueler.csv'
INTO TABLE SCHUELER
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Vorname, Nachname, Geburtsdatum, KlassenID);
```

Ergebnisprüfung mit SELECT:
```sql
SELECT * FROM SCHUELER;
```

5. Datenbereinigung
Ich habe redundante, leere oder falsche Werte bereinigt mit UPDATE und DELETE Statements.

Beispiel:
```sql
DELETE FROM SCHUELER WHERE Vorname = '' OR Nachname = '';
```

Konsistenzprüfung:
```sql
SELECT * FROM ANMELDUNG WHERE FK_SchuelerID IS NULL;
```

6. Testen der Daten
Ich habe die Werte in der Datenbank mit den CSV-Dateien verglichen und geprüft, ob sie korrekt übernommen wurden.
 
Beispiel-SELECTs:
```sql
SELECT Vorname, Nachname, Geburtsdatum FROM SCHUELER ORDER BY Nachname;
```


7. 290 zusätzliche Datensätze
Ich habe in Excel Zufallsdaten für 290 zusätzliche SchülerInnen erzeugt. Dabei habe ich Spalten gemischt und neue IDs vergeben.
Anschliessend die Daten wieder als CSV exportiert und mit LOAD DATA LOCAL INFILE eingespielt.

Beispiel-Import:
```sql
LOAD DATA LOCAL INFILE 'schueler_neu.csv'
INTO TABLE SCHUELER
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
```

8. SELECT-Aufgaben (Beispiele)

**a. Anzahl Teilnehmer bei Inge Sommer:**
```sql
SELECT COUNT(*) AS Teilnehmer
FROM ANMELDUNG A
JOIN LEHRER L ON A.FK_LehrerID = L.LehrerID
WHERE L.Vorname = 'Inge' AND L.Nachname = 'Sommer';
```

**b. Liste aller Klassen mit Anzahl SchülerInnen:**
```sql
SELECT K.Bezeichnung, COUNT(S.SchuelerID) AS Anzahl
FROM KLASSE K
LEFT JOIN SCHUELER S ON K.KlassenID = S.KlassenID
GROUP BY K.Bezeichnung
ORDER BY K.Bezeichnung;
```

**c. Alle SchülerInnen in Chor oder Elektronik:**
```sql
SELECT S.Vorname, S.Nachname
FROM SCHUELER S
JOIN ANMELDUNG A ON S.SchuelerID = A.FK_SchuelerID
JOIN FREIFACH F ON A.FK_FreifachID = F.FreifachID
WHERE F.Bezeichnung IN ('Chor', 'Elektronik');
```

**Speichern der Ausgaben:**
```sql
SELECT ... INTO OUTFILE '/path/ausgabe.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
```

**Backup:**
```sql
mysqldump -u user -p Freifaecher > Freifaecher_Backup.sql
```


## Auftrag: Opendata-Projekt

Quelle: [[zSteuerdaten Stadt Zürich]](https://www.bfs.admin.ch/bfs/de/home/statistiken.html)
- CSV analysiert und unnötige Spalten entfernt (1NF)
- Datentypen bestimmt (z. B. Jahr = INT, Quartier = VARCHAR, _p25 = DECIMAL(10,2))
- Physisches ERD erstellt mit FK-Beziehungen
- DDL-Script generiert und Tabellen angelegt
- Bulkimport via LOAD DATA LOCAL INFILE.

Analysefragen:

**Was bedeuten _p25, _p50, _p75?**
- 25., 50. (Median), 75. Perzentil → Einkommensverteilung.

**a. Quartier mit max _p75:**
```sql
SELECT Quartier, _p75 FROM Steuerdaten ORDER BY _p75 DESC LIMIT 1;
```

**b. Quartier mit min _p50:**
```sql
SELECT Quartier, _p50 FROM Steuerdaten ORDER BY _p50 ASC LIMIT 1;
```


**c. Quartier mit höchstem _p50:**
```sql
SELECT Quartier, _p50 FROM Steuerdaten ORDER BY _p50 DESC LIMIT 1;
```

**Backup:**
```sql
mysqldump -u user -p Steuerdaten > Steuerdaten_Backup.sql
```
