# Lernportfolio Modul 164 – Tag 3
- **Name:** Daphne Sibel McNamara
- **Klasse:** AP 24b
- **Modul:** 164 – Datenbanken erstellen und Daten einfügen  
- **Datum:** 27.05.2025

---


## Lernziele für Tag 3





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

  
![Mehrfach_Beziehungen](https://github.com/user-attachments/assets/fb51bfea-2bd3-41e3-9307-c98e08c6dc40)


#### Rekursion (strenge Hierarchie)
- Tabelle bezieht sich auf sich selbst (z.B. Mitarbeiter mit Vorgesetzten)
- Fremdschlüssel zeigt auf denselben Primärschlüssel in der gleichen Tabelle
- Beispiel: Firmenorganisation mit genau einem Vorgesetzten pro Mitarbeiter

  
![Rekursion](https://github.com/user-attachments/assets/42c7eb03-440a-4225-91f0-1d0daf892208)


### Einfache Hierarchie mit Zwischentabelle
- Netzwerkstruktur: Mitarbeiter können mehrere Vorgesetzte haben
- Transformationstabelle mit Fremdschlüsseln zu einer Tabelle (tbl_Hierarchie)
- Beispiel: Mehrere Projektleiter

  
![Einfache_Hierarchie](https://github.com/user-attachments/assets/772afb65-1a73-4fdb-8eec-872389113dd8)


### Stücklistenproblem
- Produkt kann sich aus mehreren anderen Produkten zusammensetzen
- Produkte und Komponenten sind in derselben Tabelle gespeichert (tbl_Produkte)
- Umsetzung: Zusätzliche Tabelle (z. B. tbl_Stückliste) für die Zusammensetzungen mit Mengenangabe
- Beispiel: Ein Schrank besteht aus Türen, Regalböden, Schrauben usw.
- Modellierung über Rekursion und eine mc:mc-Beziehung mit Zwischentabelle


![a23bd48e09ca11406474760f63e8d173](https://github.com/user-attachments/assets/5973c251-7b96-4b99-b9bd-ba67a8e5065e)





## Datenbearbeitung der Datenbasis (Repetition DML ÜK Modul 106)


### Auftrag Insert

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

### Auftrag Update, delete, alter und drop

**File:** film_update_script.sql



