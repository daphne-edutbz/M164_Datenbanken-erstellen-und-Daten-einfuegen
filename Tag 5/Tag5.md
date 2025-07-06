# Lernportfolio Modul 164 – Tag 5
- **Name:** Daphne Sibel McNamara
- **Klasse:** AP 24b
- **Modul:** 164 – Datenbanken erstellen und Daten einfügen  
- **Datum:** 10.06.2025
- Miro-Board: https://miro.com/app/board/uXjVI29IW6Y=/
---

## Lernziele für Tag 4
- Löschen in professionellen Datenbanken verstehen
- Integritätsregeln (Entitäts-, referenzielle, Bereichswert-, benutzerdefinierte Integrität)
- Fremdschlüssel-Optionen beim Löschen (ON DELETE)
- SQL: SELECT-Alias, Aggregatsfunktionen, GROUP BY, HAVING


## Gelerntes (LEARN)


### Löschen in professionellen Datenbanken
In Profisystemen selten gelöscht (DELETE), weil Informationen verloren gehen könnten. Stattdessen werden Einträge als „inaktiv“ markiert oder mit einem Austrittsdatum versehen.

**Beispiel:** 
- Mitarbeiter wird nicht gelöscht, um frühere Aktionen nachverfolgen zu können
- Kassensysteme nutzen Storno statt Löschen, damit Manipulation vermieden wird
- Auch Protokolle/Historie (z. B. Wikipedia) verhindern das Löschen – Benutzer werden gesperrt, nicht entfernt



### Datenintegrität 
Sicherstellung von Richtigkeit, Konsistenz und Vollständigkeit der Daten in der DB

**Integritätsregeln:**
1. Entitätsintegrität (Eindeutigkeit): Primärschlüssel eindeutig, keine doppelten Datensätze
2. Referenzielle Integrität: FK-Beziehungen bleiben konsistent, FK-Werte zeigen auf existierende PK
3. Bereichswertintegrität: Korrekte Datentypen (z. B. Telefonnummer als String)
4. Benutzerdefinierte Integrität: Zusätzliche Regeln, z. B. positive Werte, E-Mail-Format


### FK-Constraint-Options
- Regeln, was passiert beim Löschen in der Primärtabelle:
  - ON DELETE NO ACTION / RESTRICT: Löschen verboten, wenn FK existiert
  - ON DELETE CASCADE: Löscht abhängige FK-Datensätze automatisch → Gefahr unbeabsichtigter Löschungen
  - ON DELETE SET NULL: FK-Werte werden auf NULL gesetzt (nur wenn FK NULL erlaubt)
 

![image](https://github.com/user-attachments/assets/47481d68-16ca-4f30-b0f5-97f30a244d03)


**Beispiel:**

tbl_Kunde - Kundennummer (PK)  tbl_Bestellung - BestellID (PK) - Kundennummer (FK auf tbl_Kunde.Kundennummer)

![image](https://github.com/user-attachments/assets/cd899cc3-12d9-4d9c-beeb-25d5b7104262)



Veerhalten bei Regeln:
- ON DELETE NO ACTION (oder RESTRICT)
DELETE FROM tbl_Kunde WHERE Kundennummer = 12;
  ->Fehler: Wenn Bestellungen mit Kundennummer = 12 existieren, darf der Kunde nicht gelöscht werden.

- ON DELETE CASCADE
DELETE FROM tbl_Kunde WHERE Kundennummer = 12;
 -> Der Kunde und alle seine Bestellungen werden gelöscht.

- ON DELETE SET NULL
DELETE FROM tbl_Kunde WHERE Kundennummer = 12;
-> Kunde wird gelöscht, in tbl_Bestellung wird Kundennummer= NULL  (nur mäglich wenn FK NULL erlaubt

Bei CASCADE:
Ungespeicherter CASCADE-Löschbefehlt kann viele Daten ungewollt löschem
Beispiel:
DELETE FROM tbl_Benutzer WHERE BenutzerID = 5;
 -> könnte über CASCADE viele EInträge in tbl_Kommentare, tbö_Artikel, tbl_Aktivität usw. löschen
 (Deshalb in professionellen DBs RESTRICT oder SET NULL)

![image](https://github.com/user-attachments/assets/e66c0192-d72d-447d-b37e-ed98ce4a23e0)


#### Auftrag: Referentielle Datenintegrität

**Aufgabe 1**:

Weshalb können in professionellen Datenbanken nicht einfach so Daten gelöscht werden?
In professionellen Datenbanken wird das Löschen (DELETE) eingeschränkt, weil:
- Informationsverlust: Gelöschte Daten sind unwiderruflich weg. Verknüpfte Daten verlieren ihren Kontext (z. B. Mitarbeiter wird gelöscht → keine Nachverfolgung mehr möglich).
- Verletzung der referenziellen Integrität: Fremdschlüssel-Beziehungen würden auf nicht existente Datensätze zeigen (→ „verwaiste“ Einträge).
- Rückverfolgbarkeit geht verloren: In Anwendungen wie Buchhaltung müssen alle Änderungen nachvollziehbar bleiben. Statt Löschen wird oft Stornieren / Archivieren genutzt.
- Missbrauchsrisiko: Manipulation (z. B. im Kassensystem) könnte erleichtert werden.


Wer stellt die referentielle Integrität sicher?
Die referentielle Integrität stellt die Datenbank selbst sicher, über:
- Fremdschlüssel-Constraints (FOREIGN KEY)
- Regeln wie ON DELETE / ON UPDATE (z. B. RESTRICT, CASCADE, SET NULL, NO ACTION)


**Aufgabe 2**:

Was passiert, wenn man versucht, Basel einfach zu löschen?

Beispiel:
```sql
DELETE FROM tbl_orte WHERE ortsbezeichnung = 'Basel';
```
Fehlermeldung:

`Cannot delete or update a parent row: a foreign key constraint fails`

- In tbl_stationen steht Basel als Fremdschlüssel (FS_ID_Ort)
- Die referenzielle Integrität wird verletzt, weil die Stationen noch auf Basel zeigen
- Solange Verweise existieren, verhindert die DB das Löschen


Lösung: Richtig korrigieren
Ziel: Fehlerhafte „4000 Basel“ → „3000 Bern“ korrigieren

1. Bern in tbl_orte einfügen:
```sql
INSERT INTO tbl_orte (PLZ, Ortsbezeichnung) VALUES ('3000', 'Bern');
```

2. ID von Bern herausfinden:
```sql
SELECT * FROM tbl_orte;
```
Beispiel: ID_Ort = 6


3. Stationen auf Bern umstellen:
```sql
UPDATE tbl_stationen
SET FS_ID_Ort = 6
WHERE FS_ID_Ort = 5;
```


4. Basel löschen:
```sql
DELETE FROM tbl_orte WHERE ID_Ort = 5;
```

Ergebnis:
- Alle Stationen zeigen nun auf Bern
- Basel kann gelöscht werden, weil keine Verweise mehr existieren



#### Referentielle Datenintegrität Fortgeschritten

1. CASCADE testen

Skript läuft schon mit:
```sql
FOREIGN KEY ... ON DELETE CASCADE
```
➜ Orte samt abhängigen Stationen löschen:

```sql
DELETE FROM orte;
```
Alle abhängigen Einträge in Tabellen mit Foreign Key auf orte werden ebenfalls gelöscht

2. RESTRICT anwenden
Constraint im Skript ändern auf:
```sql
ON DELETE RESTRICT
ON UPDATE RESTRICT
```
DB neu laden

➜ Versuch: Ort löschen
```sql
DELETE FROM orte WHERE ortsname = 'Emmendingen';
```

Fehler:
`Cannot delete or update a parent row: a foreign key constraint fails`
RESTRICT blockiert das Löschen, solange abhängige Datensätze existieren.


➜ Versuch: PLZ ändern
```sql
UPDATE orte SET postleitzahl = 99999
WHERE ortsname = 'Musterhausen';
```
Fehler, wenn es als Primärschlüsselteil referenziert wird.


3. SET NULL und NO ACTION ausprobieren

Constraints ändern:
```sql
ON DELETE SET NULL
ON UPDATE SET NULL
```

DB neu laden

➜ Löschen:
```sql
DELETE FROM orte WHERE ortsname = 'Emmendingen';
```

Ergebnis:
- Emmendingen wird gelöscht
- In abhängigen Tabellen wird der Fremdschlüssel auf NULL gesetzt


➜ PLZ ändern:
```sql
UPDATE orte SET postleitzahl = 99999 WHERE ortsname = 'Musterhausen';
```
Bei ON UPDATE SET NULL:
- Referenzierende Fremdschlüssel-Felder werden auf NULL gesetzt

Skript:
```sql
-- CASCADE
ALTER TABLE stationen
DROP FOREIGN KEY fk_orte_stationen,
ADD CONSTRAINT fk_orte_stationen
FOREIGN KEY (FS_ID_Ort) REFERENCES orte(ID_Ort)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- RESTRICT
ALTER TABLE stationen
DROP FOREIGN KEY fk_orte_stationen,
ADD CONSTRAINT fk_orte_stationen
FOREIGN KEY (FS_ID_Ort) REFERENCES orte(ID_Ort)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

-- SET NULL
ALTER TABLE stationen
DROP FOREIGN KEY fk_orte_stationen,
ADD CONSTRAINT fk_orte_stationen
FOREIGN KEY (FS_ID_Ort) REFERENCES orte(ID_Ort)
ON DELETE SET NULL
ON UPDATE SET NULL;
```




### Merksatz SELECT-Aufbau
Sag Fritz, warum geht Herbert oft laufen
- SELECT
- FROM
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- LIMIT


#### Auftrag: SQL SELECT ALIAS

Beispiel:
```sql
SELECT ortsname AS Ort, postleitzahl AS PLZ
FROM orte;
```

oder mit Tabellen-Alias:

```sql
SELECT o.ortsname AS Ort, o.postleitzahl AS PLZ
FROM orte AS o;
```



#### Auftrag: Aggregatsfunktionen 

Beispiele:

Anzahl Orte:
```sql
SELECT COUNT(*) FROM orte;
Summe aller Bestellwerte:
```


```sql
SELECT SUM(order_total) FROM orders;
Durchschnittlicher Preis:
```

```sql
SELECT AVG(preis) FROM produkte;
Minimum:
```


```sql
SELECT MIN(preis) FROM produkte;
Maximum:
```

```sql
SELECT MAX(preis) FROM produkte;
```


#### Auftrag: SELECT GROUP BY

Beispiel:
```sql
SELECT customer_id, SUM(order_total) AS Gesamt
FROM orders
GROUP BY customer_id;
```


#### Auftrag: SELECT GROUP BY ORDER

Beispiel:
```sql
SELECT customer_id, SUM(order_total) AS Gesamt
FROM orders
GROUP BY customer_id
ORDER BY Gesamt DESC;
```


#### Auftrag: SELECT HAVING

Beispiel:
```sql
SELECT customer_id, SUM(order_total) AS Gesamt
FROM orders
GROUP BY customer_id
HAVING SUM(order_total) > 500;
```




## Checkpoint-Fragen

**Vier Aspekte der Datenintegrität**
- Entitätsintegrität
- Referenzielle Integrität
- Bereichswertintegrität
- Benutzerdefinierte Integrität

**Unterschied Datenintegrität vs. Datenkonsistenz**
- Integrität = Regeln und Sicherheit für korrekte Daten.
- Konsistenz = Zustand der Daten, regelkonform und fehlerfrei.

Gefahr bei ON DELETE CASCADE
- Abhängige Datensätze werden automatisch mit gelöscht → unbeabsichtigter Datenverlust möglich

Unterschied COUNT(*) vs. COUNT(attr)
- COUNT(*): Alle Zeilen inkl. NULL

- COUNT(attr): Zählt nur Zeilen mit nicht-NULL-Werten in attr.

**Beispiel SELECT mit WHERE BETWEEN**
```sql
SELECT * FROM orders WHERE order_date BETWEEN '2025-01-01' AND '2025-03-31';
```

**Worauf bei HAVING achten**
- HAVING filtert nur nach Aggregatwerten (nach GROUP BY), nicht auf Einzelebenen wie WHERE.
