# Tag 1 – Einführung & Repetition M162

- **Name:** Daphne Sibel McNamara
- **Klasse:** AP 24b
- **Modul:** 164 – Datenbanken erstellen und Daten einfügen  
- **Datum:** 13.05.2025  
- **Thema:** Einführung in das Modul, Repetition von M162, DB-Installation, Datenmodellierung, Normalisierung  
- **Tools:** MySQL/MariaDB, XAMPP, Docker, AWS, MySQL Workbench, Miro
- Miro-Board: https://miro.com/app/board/uXjVI29IW6Y=/
---

---

## Lernziele

- Repetition von ERM, ERD und Normalisierung (M162)
- Einführung in die Modellierungsarten: konzeptionell → logisch → physisch
- Installation eines DBMS (MariaDB, MySQL, Workbench etc.)
- Erste praktische Übung mit Datenmodellierung („Tourenplaner“)
- Verständnis der **Wissenstreppe**

---

## Inhalte & Übungen

### 1. Wiederholung von Fachbegriffen & Konzepten

- Unterschied:  
  - **ERM** = konzeptionelles Modell  
  - **ERD** = logisches Modell  
  - **physisches Modell** = SQL/DDL  

- Schritte:
  1. Konzeptionelles Design (Nomen = Entitäten, Beziehungen skizzieren)
  2. Logisches Design (Beziehungen + Attribute + Kardinalitäten)
  3. Physisches Design (SQL Tabellen erstellen per `CREATE TABLE`)

---

### 2. Normalisierung

#### 1. Normalform (1NF)
- **Ziel:** Werte atomar machen (z. B. keine Kombis wie „Rainstrasse 27“ in einem Feld)
- Beispiel:
  ```text
  Müller Rainstrasse 27 → Müller | Rainstrasse | 27
  ```

#### 2. Normalform (2NF)

- **Ziel:** Logische Gruppen bilden
- Keine partiellen Abhängigkeiten

#### 3. Normalform (3NF)

- **Ziel:** Keine transitiven Abhängigkeiten
- Bsp.: `PLZ → Ort` auslagern

> Aussage Dozent: „3NF braucht man nicht immer, aber in der Regel sinnvoll.“

---

### 3. Übung „Tourenplaner“

**Auftrag:**

- Auf Papier: ERM mit Nomen & Beziehungen erstellen
- In Workbench übertragen: ERD modellieren
- In SQL umsetzen: Tabellen erstellen via DDL

**Arbeitsschritte:**

1. Textanalyse: Nomen anstreichen (für Entitäten)
2. Beziehungen und Kardinalitäten ableiten
3. Attribute zuordnen (Primary/Foreign Keys)
4. SQL-Statements generieren lassen

> **Tipp**: „Forward Engineering“ in Workbench nutzen → SQL erzeugen

---

### 4. Die Wissenstreppe

| Stufe           | Bedeutung                | Beispiel: Wechselkurs                  |
| --------------- | ------------------------ | -------------------------------------- |
| **Zeichen**     | Rohdaten ohne Kontext    | `1.08`, `USD`, `CHF`                   |
| **Daten**       | Struktur, noch kein Sinn | `1.08 USD/CHF`                         |
| **Information** | Daten mit Bedeutung      | 1 USD = 1.08 CHF                       |
| **Wissen**      | Zusammenhang erkennen    | Wechselkurs hängt von Zinsen ab        |
| **Können**      | Wissen anwenden          | USD kaufen bei erwarteter Zinserhöhung |
| **Handeln**     | Zielgerichtet umsetzen   | USD kaufen im richtigen Moment         |
| **Kompetenz**   | Wiederholter Erfolg      | Langfristig gewinnbringender Handel    |

---

### 5. Installation DBMS

**Installationsvarianten:**

| Variante  | Beschreibung                   |
| --------- | ------------------------------ |
| MariaDB   | Lokal, „Long-Term Support“     |
| XAMPP     | Komplettpaket mit PHP & MySQL  |
| Docker    | Containerisierte Lösung        |
| AWS       | Cloudbasierte Datenbank        |
| Workbench | GUI zur Modellierung & Abfrage |

---

### 6. Repetitionsfragen (aus dem Unterricht)

- Welche Stufen hat die Wissenstreppe?
- Wie werden Netzwerkbeziehungen im logischen Modell dargestellt?
- Was sind Anomalien in Datenbanken?
- Welche Arten von Redundanzen gibt es?

---

## Reflexion

Heute war ein guter Einstieg ins Modul. Ich habe nochmals die Grundlagen aus M162 repetiert und besser verstanden, wie ERM, ERD und SQL-Design zusammenspielen. Besonders hilfreich war die **Visualisierung der Normalformen** und das praktische Beispiel mit der „Tourenplaner“-Übung.

Schwierigkeiten hatte ich bei der Unterscheidung von 2NF und 3NF, aber durch das Beispiel mit `PLZ → Ort` wurde es klarer.

---


## Quellen & Referenzen

- Modul 162: Daten analysieren & modellieren
- Wikipedia: [Datenmodell](https://de.wikipedia.org/wiki/Datenmodell)
- Unterrichtsfolien M164
