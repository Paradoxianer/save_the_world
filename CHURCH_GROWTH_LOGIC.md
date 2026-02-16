# 📖 Logik der Gemeindewachstums-Schwellen

Diese Datei definiert die spielerische Umsetzung von Jüngerschaft und geistlicher Multiplikation. Wachstum wird hier nicht als "Zahl" verstanden, sondern als "Befähigung" durch das Überwinden von Schwellen.

## 🚀 Das Prinzip der Multiplikation & Schwellen

Im Spiel arbeiten wir mit **Wachstumsschwellen**. Um eine Schwelle zu überschreiten, reicht es nicht, nur Ressourcen zu sammeln – es muss eine qualitative Änderung stattfinden (Befähigung).

### 1. Die "Enable Next Stage" Mechanik (Stage-Gates)
*   Jede Stufe hat ein **Maximum** an Mitgliedern (das aktuelle "Glasdach").
*   Um dieses Dach anzuheben, muss ein spezifischer **Schlüsseltask (Blocker-Task)** erfolgreich abgeschlossen werden (z.B. "Essen in meiner Wohnung" in Stage 0 oder "Saal mieten" in Stage 3).
*   Erst nach Abschluss dieses Tasks wird die *nächste Stufe ermöglicht* (Enabled). Das Ressourcen-Maximum steigt.
*   Der tatsächliche **Stufenaufstieg** (mit Glückwunsch-Dialog) findet erst statt, wenn die Mitgliederzahl die neue Schwelle real erreicht.

### 2. Visuelle Markierung von Blocker-Tasks
*   Tasks, die für den Stufenaufstieg zwingend sind, werden im UI besonders hervorgehoben (z.B. rote Umrandung oder spezielles Icon), damit der Spieler weiß: "Das ist meine aktuelle Priorität".

### 3. Stage-Fallback (Low Priority)
*   Sinkt die Mitgliederzahl (z.B. durch Streit) unter die Schwelle der *vorherigen* Stufe, kann ein Downgrade erfolgen.
*   **Konsequenz:** Spezifische Aufgaben der höheren Stufe gehen wieder verloren, bis die Schwelle erneut stabil überschritten wird.

---

## 🏗 Struktur der Schwellen & Fokus-Phasen

| Stufe | Phase | Blocker-Task (Beispiel) | Jüngerschafts-Fokus |
|-------|-------|-------------------------|----------------------|
| 0     | **Einstieg** | Essen in meiner Wohnung | Vertrauen & Einladung |
| 1-3   | **Clan** | Saal mieten / Korpsrat | Delegation & Struktur |
| 4-10  | **Gemeinde** | Leiter-Training | Leiter von Leitern |
| 11-20 | **Bewegung** | Pionier-Team aussenden | DNA-Multiplikation |

---

## ⚖️ Balancing-Regeln für Schwellen
*   **Blocker-Tasks** sollten höhere Anforderungen an "Faith" und "Wisdom" haben als Standard-Tasks.
*   Sie symbolisieren den "Glaubensschritt", der für die nächste Ebene nötig ist.
