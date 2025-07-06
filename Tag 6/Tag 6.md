# Lernportfolio Modul 164 – Tag 6
- **Name:** Daphne Sibel McNamara
- **Klasse:** AP 24b
- **Modul:** 164 – Datenbanken erstellen und Daten einfügen  
- **Datum:** 17.06.2025
- Miro-Board: https://miro.com/app/board/uXjVI29IW6Y=/
---

## Lernziele für Tag 6
- Subqueries (Subselects / Unterabfragen) in SQL verstehen und anwenden
- Unterschied zwischen skalaren und nicht-skalaren Subqueries
- Bulk-Import mit LOAD DATA (LOCAL) INFILE
- CSV-Daten importieren und Felder/Zeichensätze anpassen
- Datenbereinigung beim Import (Datumsformate, fehlende Felder)
- INSERT INTO ... SELECT für Normalisierung


## Gelerntes (LEARN)

### Subqueries/Unterabfrage
- Abfrage innerhalb einer anderen Abfrage
- Oft in WHERE-, FROM-, HAVING- oder SELECT-Klauseln
- Dient dazu, Bedingungen oder Datenmengen dynamisch zu ermitteln

Beispiel für Subquery in WHERE IN:
```sql
SELECT id, name
FROM t_mitarbeiter
WHERE abt_id IN (
  SELECT abt_id
  FROM t_abteilungen
  WHERE abt.name = 'PROD'
);
```
![image](https://github.com/user-attachments/assets/f3c9a16a-a1f4-4a1f-ab59-b538c6378671)


### Skalare Subquery
- Gibt genau eine Spalte und eine Zeile zurück
- Kann mit =, >, <, >=, <= verglichen werden.

Beispiel:
```sql
SELECT city_destination, ticket_price
FROM one_way_ticket
WHERE ticket_price < (
  SELECT MIN(ticket_price)
  FROM one_way_ticket
  WHERE city_destination = 'Bariloche'
    AND city_origin = 'Paris'
)
AND city_origin = 'Paris';
```
Die Subquery ermittelt den günstigsten Preis. Die äussere Abfrage sucht alle günstigeren Tickets.


#### Nicht-skalare Subquery
- Liefert mehrere Werte (z. B. für IN oder NOT IN)

Beispiel:
```sql
SELECT name, age, country
FROM users
WHERE country IN (
  SELECT name
  FROM country
  WHERE region = 'Europa'
);
```
Filtert alle User aus europäischen Ländern

![image](https://github.com/user-attachments/assets/459a13e6-172c-4bd0-b349-3133d0a75c35)



#### Subquery mit JOIN
- Subquery kann innerhalb einer JOIN-Bedingung genutzt werden
```sql
SELECT customers.ContactName, orders.orderdate
FROM customers
INNER JOIN orders ON customers.customerid = orders.customerid
WHERE orders.orderdate IN (
  SELECT MAX(orderdate)
  FROM orders
  GROUP BY customerid
);
```
Liefert alle Bestellungen mit dem letzten Bestelldatum pro Kunde

Weiteres Beispiel:
```sql
SELECT MAX(average.average_price)
FROM (
  SELECT product_category, AVG(price) AS average_price
  FROM product
  GROUP BY product_category
) average;

SELECT Name
FROM Mitarbeiter m
WHERE EXISTS (
  SELECT 1
  FROM Projekte p
  WHERE m.MitarbeiterID = p.MitarbeiterID AND p.Status = 'Aktiv'
);
```
Operatoren: IN, EXISTS, NOT EXISTS, > ALL, = ANY usw.


![image](https://github.com/user-attachments/assets/49c6e65a-2a80-48a6-b33b-3c8dd19915e3)



#### Auftrag: SUBQUERY – Datenbank buchladen

##### Teil 1: Skalare Subqueries

**Welches ist das teuerste Buch?**
```sql
SELECT titel, einkaufspreis
FROM buch
WHERE einkaufspreis = (SELECT MAX(einkaufspreis) FROM buch);
```


**Billigstes Buch**
```sql
SELECT titel, einkaufspreis
FROM buch
WHERE einkaufspreis = (SELECT MIN(einkaufspreis) FROM buch);
```


**Alle Bücher über Durchschnittspreis**
```sql
SELECT titel, einkaufspreis
FROM buch
WHERE einkaufspreis > (SELECT AVG(einkaufspreis) FROM buch);
```


**Über Durchschnitt aller Thriller**
```sql
SELECT titel, einkaufspreis
FROM buch
WHERE einkaufspreis > (
    SELECT AVG(einkaufspreis) FROM buch WHERE sparte = 'Thriller'
);
```


**Alle Thriller über Durchschnitt aller Thriller**
```sql
SELECT titel, einkaufspreis
FROM buch
WHERE sparte = 'Thriller'
AND einkaufspreis > (
    SELECT AVG(einkaufspreis) FROM buch WHERE sparte = 'Thriller'
);
```

**Alle Bücher mit überdurchschnittlichem Gewinn (ohne ID 22)**
Gewinn = verkaufspreis - einkaufspreis

```sql
SELECT titel, verkaufspreis - einkaufspreis AS gewinn
FROM buch
WHERE (verkaufspreis - einkaufspreis) > (
    SELECT AVG(verkaufspreis - einkaufspreis)
    FROM buch
    WHERE id <> 22
);
```



##### Teil 2: Subquery nach FROM

**Summe der Durchschnittspreise der Sparten (ohne Humor und ohne ≤10€)**
```sql
SELECT SUM(avg_preis) AS summe
FROM (
    SELECT sparte, AVG(einkaufspreis) AS avg_preis
    FROM buch
    WHERE sparte <> 'Humor'
    GROUP BY sparte
    HAVING AVG(einkaufspreis) > 10
) AS sub;
```

**Bekannte Autoren (>4 Bücher)**
Zunächst Subquery:
```sql
SELECT autor_id, COUNT(*) AS anzahl
FROM buch
GROUP BY autor_id
HAVING COUNT(*) > 4;
```
→ Dann Anzahl solcher Autoren zählen:
```sql
SELECT COUNT(*)
FROM (
    SELECT autor_id
    FROM buch
    GROUP BY autor_id
    HAVING COUNT(*) > 4
) AS bekannte_autoren;
```

**Liste für Chef (Verlage mit <10€ Gewinn, prüfen ob ≤7€)**

1. Subselect: Durchschnittlicher Gewinn pro Verlag

```sql
SELECT verlag_id, AVG(verkaufspreis - einkaufspreis) AS avg_gewinn
FROM buch
GROUP BY verlag_id
HAVING avg_gewinn < 10;
```

2. Chef-Frage prüfen:
```sql
SELECT AVG(avg_gewinn) AS durchschnitt
FROM (
    SELECT verlag_id, AVG(verkaufspreis - einkaufspreis) AS avg_gewinn
    FROM buch
    GROUP BY verlag_id
    HAVING avg_gewinn < 10
) AS sub
WHERE avg_gewinn <= 7;
```



### Bulk-Import mit LOAD DATA INFILE
- Schneller Import von CSV-Dateien in Datenbanken (ca. 20x schneller als manuelles Einfügen)
- Prüfungsrelevant: Syntax kennen und anwenden können.

Grundsyntax:
```sql
LOAD DATA LOCAL INFILE 'C:/path/import.csv'
INTO TABLE tabellenname
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

- LOCAL: Datei wird vom Client gelesen
- Feldertrenner und Zeilenende definierbar
- Zeilen können mit IGNORE 1 ROWS übersprungen werden (Header)

![image](https://github.com/user-attachments/assets/b965d66a-da3a-42a3-a841-eaa62a96fc87)


**Wichtige Optionen**

- Zeichensatz anpassen:
```sql
CHARACTER SET utf8mb4
```

- Datumsformat transformieren:
```sql
SET Geb_Datum = STR_TO_DATE(@GD, '%d.%m.%Y')
```

Beispiel für Anpassung:
```sql
LOAD DATA LOCAL INFILE 'C:/M164/bsp1.csv'
REPLACE
INTO TABLE tbl_Beispiel
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(ID_Beispiel, Name, @GD, Zahl, FS)
SET Geb_Datum = STR_TO_DATE(@GD, '%d.%m.%Y');
```


**Varianten**
- Spaltenreihenfolge ändern
- Spalten auslassen mit Dummy-Variablen (@Skip)
- Fehlende Felder mit Default-Werten setzen
- Werte mit CASE umwandeln (z. B. Texte zu IDs)

Beispiel für CASE:
```sql
SET FS = CASE
  WHEN @Ort = 'Zuerich' THEN 1
  WHEN @Ort = 'Basel' THEN 2
  ELSE NULL
END;
```


**Wichtige Tipps**
- Server- und Client-Settings prüfen:
```sql
SET GLOBAL local_infile=1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'secure_file_priv';
```
- Achtung bei Pfadangaben (immer / statt )
- Workbench: OPT_LOCAL_INFILE=1 in Verbindungseinstellungen setzen


#### Auftrag mit Tutorial (CSV-Import)

**Welcher Zeichensatz ist standardmässig bei Ihrem DBMS eingestellt?**
Prüfen mit:
```sql
SHOW VARIABLES LIKE 'character_set_database';
```
Typische Antwort bei MySQL/MariaDB: `utf8mb4`


**Hinweis: CHARACTER SET beim Import**
- Beim LOAD DATA INFILE kann man (und sollte man bei Abweichungen!) explizit den Zeichensatz angeben:
```sql
LOAD DATA INFILE 'personen.csv'
CHARACTER SET utf8
INTO TABLE personen ...
```


#### Aufgabe: CSV-Datei Personen untersuchen
Bevor du importierst:
- Öffne die Datei in einem Texteditor

Prüfen:
- Trennzeichen → z. B. , oder ;
- Umgebende Anführungszeichen? "
- Kopfzeile (Spaltennamen)? → meist ja
- Zeichensatz (z. B. UTF-8, Windows-1252)
- Datumsformat → ISO (YYYY-MM-DD) oder deutsch (DD.MM.YYYY)


**Import 500 Zeilen Personen.csv**
Beispiel:
```sql
LOAD DATA LOCAL INFILE '/path/to/personen.csv'
CHARACTER SET utf8
INTO TABLE personen
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, vorname, nachname, geburtsdatum, adresse, plz, ort);
```

**Prüfen der Zeilenzahl:** 
```sql
SELECT COUNT(*) FROM personen;
```
Sollte 500 ergeben


**Import weitere 100 Datensätze aus Personen_DE → Fehler?**
Typische Ursachen:
- Andere Spaltenreihenfolge
- Andere Trennzeichen
- Falscher Zeichensatz (z. B. Windows-1252 → Umlaute kaputt)
- Andere Datumsformate

Beispielproblem:
`Müller → Müller wird zu M�ller`

Lösung:
- CHARACTER SET anpassen
- evtl. vorher umkonvertieren (z. B. iconv)
- Datumsformat konvertieren




**SQL-Befehl zum Löschen der Datenbasis
```sql
DROP DATABASE db_personen;
```



#### Auftrag: Datenbasis DB_Adressen

**CREATE DATABASE**
```sql
CREATE DATABASE db_adressen;
USE db_adressen;
```

**Temporäre Tabelle tbl_Adr**

Beispiel:
```sql
CREATE TABLE tbl_Adr (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vorname VARCHAR(50) NOT NULL,
    nachname VARCHAR(50) NOT NULL,
    strasse VARCHAR(100) NOT NULL,
    plz CHAR(5) NOT NULL,
    ort VARCHAR(50) NOT NULL,
    geburtsdatum DATE
);
```

**Bulkimport**
```sql
LOAD DATA LOCAL INFILE '/path/to/adressen.csv'
CHARACTER SET utf8
INTO TABLE tbl_Adr
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
```

**Sonderzeichen prüfen:**
```sql
SELECT * FROM tbl_Adr WHERE vorname LIKE '%ü%' OR nachname LIKE '%ss%';
```


**Normalisierung (3NF):**
→ Tabellen:
```sql
CREATE TABLE tbl_Ort (
    ort_id INT AUTO_INCREMENT PRIMARY KEY,
    plz CHAR(5) NOT NULL,
    ort VARCHAR(50) NOT NULL
);

CREATE TABLE tbl_Str (
    str_id INT AUTO_INCREMENT PRIMARY KEY,
    strasse VARCHAR(100) NOT NULL
);

CREATE TABLE tbl_Person (
    person_id INT AUTO_INCREMENT PRIMARY KEY,
    vorname VARCHAR(50) NOT NULL,
    nachname VARCHAR(50) NOT NULL,
    geburtsdatum DATE,
    str_id INT,
    ort_id INT,
    FOREIGN KEY (str_id) REFERENCES tbl_Str(str_id),
    FOREIGN KEY (ort_id) REFERENCES tbl_Ort(ort_id)
);
```


**Übertragen mit INSERT INTO … SELECT …**
```sql
INSERT INTO tbl_Ort (plz, ort)
SELECT DISTINCT plz, ort FROM tbl_Adr;

INSERT INTO tbl_Str (strasse)
SELECT DISTINCT strasse FROM tbl_Adr;

INSERT INTO tbl_Person (vorname, nachname, geburtsdatum, str_id, ort_id)
SELECT
    a.vorname, a.nachname, a.geburtsdatum,
    s.str_id,
    o.ort_id
FROM tbl_Adr a
JOIN tbl_Str s ON a.strasse = s.strasse
JOIN tbl_Ort o ON a.plz = o.plz AND a.ort = o.ort;
```



**Kontrolle mit JOIN**
```sql
SELECT p.person_id, p.vorname, p.nachname, p.geburtsdatum,
       s.strasse, o.plz, o.ort
FROM tbl_Person p
JOIN tbl_Str s ON p.str_id = s.str_id
JOIN tbl_Ort o ON p.ort_id = o.ort_id;
```



**Direkter Import ohne tbl_Adr**
- Spaltenreihenfolge, Defaults und FKs beachten
- LOAD DATA direkt in tbl_Ort / tbl_Str / tbl_Person geht, wenn man die CSV passend splittet oder mehrere CSV hat




### INSERT INTO ... SELECT
- Daten aus einer Tabelle in eine andere einfügen
- Hilfreich bei der Normalisierung.

Beispiel:
```sql
INSERT INTO customers (name, email, address)
SELECT name, email, address
FROM new_customers;
```
Wird für die Aufteilung in 3NF verwendet




## Checkpoint-Fragen

**Was ist der Einsatz von Subqueries?**
- Subqueries ermöglichen es, Zwischenergebnisse in einer einzigen SQL-Abfrage zu berechnen und weiterzuverwenden. So kann man komplexe Filter, Aggregationen oder Bedingungen formulieren, ohne mehrere separate Abfragen ausführen zu müssen.

**Unterschied skalare vs. nicht-skalare Subquery**
- Skalare Subquery: Liefert genau 1 Wert (z. B. Zahl, Datum)
- Nicht-skalare Subquery: Liefert mehrere Zeilen/Spalten (z. B. Tabellen)

**Gefahren bei Subselect**
- Performanceprobleme bei grossen Datenmengen
- Logische Fehler, wenn Subquery mehrere statt einer Zeile liefert
- Abhängigkeit vom DBMS-Optimizer

**IGNORE 1 LINES in LOAD DATA**
- Überspringt die Kopfzeile mit den Spaltennamen. Ohne diese Option würde sie als Datensatz importiert.

**Problem mit Windows-CSV und LINES TERMINATED BY '\n'**
- Windows-CSV nutzt oft \r\n
- Bei falscher Einstellung wird \r als Zeichen am Ende der letzten Spalte mit importiert
- z. B. "Müller\r"

**Lösung:**
```sql
LINES TERMINATED BY '\r\n'
```

**Einstellung für Client-Import**
local_infile aktivieren:
```sql
SET GLOBAL local_infile = 1;
```


**Import in anderer Spaltenreihenfolge**
```sql
LOAD DATA INFILE 'file.csv'
INTO TABLE personen
FIELDS TERMINATED BY ';'
IGNORE 1 LINES
(nachname, vorname, geburtsdatum, adresse, plz, ort);
```

