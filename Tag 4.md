# Lernportfolio Modul 164 – Tag 4
- **Name:** Daphne Sibel McNamara
- **Klasse:** AP 24b
- **Modul:** 164 – Datenbanken erstellen und Daten einfügen  
- **Datum:** 03.06.2025
- Miro-Board: https://miro.com/app/board/uXjVI29IW6Y=/
---

## Lernziele für Tag 4
- JOINs in SQL (INNER, LEFT, RIGHT)
- Referenzielle Integrität und Foreign-Key-Constraints
- Beziehungstypen (1:1, 1:n, m:n)
- Forward Engineering in MySQL Workbench für Beziehungen mit Constraints
- Mengenlehre als Grundlage für JOIN-Logik verstehen


## Gelerntes (LEARN)

### JOINs in SQL
- verknüpfen Tabellen basierend auf einem gemeinsamen Attribut (meist Primär- und Fremdschlüssel)
- dadurch kann man Daten aus mehreren Tabellen in einem SELECT kombinieren

![image](https://github.com/user-attachments/assets/db6fb807-f308-4976-900a-6ad9e6bc4288)


#### Arten von JOINs:

**INNER JOIN**
- liefert nur Datensätze mit Übereinstimmungen in beiden Tabellen.
→ Schnittmenge (∩)
```sql
SELECT c.customer_id, o.order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;
```
Nur Kunden mit Bestellung werden angezeigt


**LEFT JOIN**
- liefert alle Zeilen der linken Tabelle + passende aus der rechten
- Fehlende rechte Werte → NULL
→ "Alle aus links, Schnittmenge ergänzt"
```sql
SELECT c.customer_id, o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
```
Zeigt auch Kunden ohne Bestellung (mit NULL in order_date)


**RIGHT JOIN**
- liefert alle Zeilen der rechten Tabelle + passende aus der linken
- Fehlende linke Werte → NULL
```sql
SELECT c.customer_id, o.order_date
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;
```

**FULL OUTER JOIN**
- gibt alle Zeilen aus beiden Tabellen zurück (inkl. solcher ohne Übereinstimmung)
- In MySQL muss man das über UNION von LEFT und RIGHT JOIN nachbauen
→ Vereinigungsmenge (∪)


### Mengenlehre (als Basis für JOINs)
- Tabellen = Mengen (A, B)
- Elemente = Datensätze
- ∩ = INNER JOIN
![image](https://github.com/user-attachments/assets/e6e6ed00-2992-4839-b665-1644b3865640)
- ∪ = FULL OUTER JOIN
![image](https://github.com/user-attachments/assets/34bf2ffd-9a36-4b8b-a813-235f91c9cf6f)
- Teilmengen, Schnittmengen und Vereinigungen beschreiben JOIN-Logik mathematisch

#### Auftrag "Mengenlehre"
**Aufgabe 1** Gegeben sind die fünf Mengen:
- A={c,e,z,r,d,g,u,x}
- B={c,e,g}
- C={r,d,g,t}
- D={e,z,u}
- E={z,r,u}

Beurteilen Sie die folgenden Aussagen:

a) B ⊂ A
Ja, 
Alle Elemente von B sind in A enthalten: c, e, g ∈ A

b) C ⊂ A
Nein, 
C enthält das Element t, das nicht in A ist

c) E ⊂ A
Ja,
E = {z, r, u}, alle in A enthalten

d) B ⊂ C
Nein
z. B. c ∈ B, aber c ∉ C

e) E ⊂ C
Nein
z. B. z ∈ E, aber z ∉ C


**Aufgabe 2**
Gegeben:
- A={1;2;3;4;5}
- B={2;5}
- C={3;5;7;9}

a) A ∩ B
= {2,5}

b) A ∪ C
= {1,2,3,4,5,7,9}

c) Bᶜ (im Kontext: Komplement bezogen auf A)
= A \ B = {1,3,4}

d) B\C
= {2,5} \ {3,5,7,9} = {2}

e) C\B
= {3,5,7,9} \ {2,5} = {3,7,9}


**Eigene Beispiele zu ⊂, ∩, ∪**

Beispiel 1: ⊂ (echte Teilmenge)
- A = {Äpfel, Birnen, Bananen}
- B = {Äpfel, Bananen}
B ⊂ A

Beispiel 2: ∩ (Schnitt)
- A = {Playstation, Xbox, PC}
- B = {PC, Nintendo Switch}
A ∩ B = {PC}

Beispiel 3: ∪ (Vereinigung)
- A = {Gemüse, Obst}
- B = {Fleisch, Fisch}
A ∪ B = {Gemüse, Obst, Fleisch, Fisch}

Beispiel 4: \ (Differenz)
- A = {Shooter, Adventure, RPG}
- B = {Adventure}
A \ B = {Shooter, RPG}


### Referenzielle Integrität

**Definition:**
- stellt sicher, dass Fremdschlüssel (FK) immer auf einen gültigen Primärschlüssel (PK) in einer anderen (oder derselben) Tabelle verweisen
→ Verhindert „verwaiste“ Datensätze und Dateninkonsistenzen

**Beispiel:** Tabelle Kunde (PK: kunden_id)

Tabelle Bestellung (FK: kunden_id → Kunde.kunden_id)
→ Jede Bestellung verweist auf existierenden Kunden



### Primärschlüssel (PK) und Fremdschlüssel (FK)
- **PK:** eindeutig identifizierendes Attribut (oder Kombination). Beispiel: ID-Spalte
- **FK:** verweist auf PK einer anderen Tabelle → stellt die Beziehung her
FK in einer Tabelle ist der PK in einer anderen Tabelle abgebildet



### Beziehungstypen und Constraints


![image](https://github.com/user-attachments/assets/454c53d5-e8c2-4867-a755-4dee7472de4e)

| Beziehungstyp | Darstellung in DB             | Umsetzung (Constraints)                  |
| ------------- | ----------------------------- | ---------------------------------------- |
| 1:1           | Ja                            | FK mit NOT NULL und UNIQUE               |
| 1\:n (1\:mc)  | Ja                            | FK mit (optionalem) NOT NULL             |
| m\:n          | Ja (nur über Zwischentabelle) | Zwei FKs mit NOT NULL in Zwischentabelle |



Beispiel `m:n`:
Projekt ↔ Mitarbeiter
- Zwischentabelle Projekt_Mitarbeiter mit:
- FK_Projekt → Projekt.ID
- FK_Mitarbeiter → Mitarbeiter.ID


### Umsetzung in SQL / Workbench
Constraints = Regeln in DB, die Konsistenz sichern

Beim Forward Engineering werden diese automatisch generiert:
- NOT NULL: kein leerer Wert erlaubt (FK muss gesetzt sein)
- UNIQUE: FK-Wert darf nur 1x vorkommen (1:1-Beziehung)
- FOREIGN KEY: referentielle Integrität

```sql
ALTER TABLE Bestellung
  ADD CONSTRAINT FK_Bestellung_Kunde
  FOREIGN KEY (kunden_id)
  REFERENCES Kunde (kunden_id);
```

**UNIQUE-Constraint Beispiel:**
```sql
ALTER TABLE Ausweis
  ADD UNIQUE (fahrer_id);
```

![image](https://github.com/user-attachments/assets/612e9933-9580-4822-9f11-bb74f378e8b1)


### Fragen (Checkpoint)

**Was ist referenzielle Integrität?**
→ Sicherstellung, dass FK nur auf gültige PK-Werte verweist. Beispiel: Bestellung muss auf existierenden Kunden zeigen.

**Welche Constraints kann eine Beziehung haben?**
- NOT NULL
- UNIQUE
- FOREIGN KEY

**Unterschied LEFT JOIN und RIGHT JOIN?**
- LEFT JOIN → Alle aus linker Tabelle, rechte Werte optional (NULL)
- RIGHT JOIN → Alle aus rechter Tabelle, linke Werte optional (NULL)

**Wie wird 1:1- und c:m-Beziehung umgesetzt?**
- 1:1 → FK mit NN und UNIQUE
- c:m (m:n) → über Zwischentabelle mit zwei FKs

**Nachteil bei FK ohne Constraint?**
→ Dateninkonsistenz möglich, FK kann auf nicht existierenden PK zeigen.

**Folge FK auf nicht existierenden PK:**
- Mit Constraint → Fehler beim INSERT/UPDATE
- Ohne Constraint → Insert möglich → Integritätsproblem












