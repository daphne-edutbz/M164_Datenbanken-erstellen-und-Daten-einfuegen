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

#### Rekursion (strenge Hierarchie)
- Tabelle bezieht sich auf sich selbst (z.B. Mitarbeiter mit Vorgesetzten)
- Fremdschlüssel zeigt auf denselben Primärschlüssel in der gleichen Tabelle
- Beispiel: Firmenorganisation mit genau einem Vorgesetzten pro Mitarbeiter

### Einfache Hierarchie mit Zwischentabelle
- Netzwerkstruktur: Mitarbeiter können mehrere Vorgesetzte haben
- Transformationstabelle mit Fremdschlüsseln zu einer Tabelle (tbl_Hierarchie)
- Beispiel: Mehrere Projektleiter

### Stücklistenproblem
- 


