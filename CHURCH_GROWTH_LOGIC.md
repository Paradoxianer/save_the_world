# 📖 Logik der Gemeindewachstums-Schwellen

Diese Datei definiert die strategische und geistliche Logik des Wachstums. Sie dient als Leitfaden für das Game-Balancing und die Task-Strukturierung.

## 🚀 Kern-Prinzip: Qualitative Transformation

Wachstum in "Save the World" ist kein linearer Prozess, sondern ein Wechsel der Betriebssysteme. Jede Phase erfordert eine neue Art der Leitung.

### 1. Zunehmende Komplexität & Geistliche Dimension (Task-Chaining)
Mit steigender Stage werden Aufgaben nicht nur teurer, sondern auch "fragmentierter".
*   **Anfang (Stage 0-3):** Aufgaben sind monolithisch. Ein Klick erledigt alles (z.B. "Gottesdienst feiern").
*   **Wachstum (Stage 4-10):** Aufgaben erfordern Vorbereitung. Ein Gottesdienst braucht vorher "Gebet" und "Predigtvorbereitung".
*   **Reife (Stage 11+):** Komplexe Abläufe spiegeln die Realität großer Organisationen wider. Leitung bedeutet hier, Systeme zu führen, ohne die Basis zu verlieren.

### 2. Die Management-Falle: Solo-Weg vs. Delegation
*   **Der Solo-Pfad:** Der Spieler kann versuchen, alles selbst zu machen. Das führt ab Stage 4-5 zu massivem Stress und zeitlichen Engpässen (`Time` Flaschenhals). Es ist der Weg des "Ausbrennens".
*   **Delegation & Multiplikation:** Ab der "Gemeinde-Phase" ist Delegation der einzige Weg. Der Einsatz von `AutoExecuteModifier` (Automatisierung) und `MultiplyRes` (Multiplikation) ist essenziell. Erfolg bedeutet, dass Dinge ohne direktes Zutun des Spielers passieren.

### 3. Das "Progression-Swap-Pattern" (Race Condition Schutz) 🛡️
Um Endlosschleifen und logische Fehler zu vermeiden (z.B. ein Tutorial-Task, der sich selbst immer wieder triggert), gilt folgende Regel für alle Story-relevanten Aufgaben:
*   **Einmalige Trigger:** Aufgaben, die neue Möglichkeiten freischalten (z.B. "Mein erster Hausbesuch"), müssen sich bei Abschluss sofort selbst entfernen (`RemoveTask`) und durch eine "Routine-Version" (z.B. "Hausbesuch (Routine)") ersetzen.
*   **Golden Gate Tasks:** Ein Meilenstein-Task (`isMilestone: true`), der das Limit erhöht, darf niemals dauerhaft in der Liste bleiben. Er entfernt sich selbst und schaltet die nächste Stufe oder Wartungs-Aufgaben frei.
*   **Symmetrie:** Wenn A den Task B freischaltet, sollte A verschwinden, sobald B aktiv ist, um die UI übersichtlich zu halten.

### 4. Krisen-Management (Rote Tasks)
Krisen-Tasks dienen als Stress-Test für die Organisation.
*   **Selbstreinigungs-Regel:** Krisentasks müssen sich nach Abschluss (Erfolg ODER Misserfolg) immer selbst aus der Taskliste entfernen (`RemoveTask`). Eine gelöste Krise darf die Liste nicht weiter blockieren.
*   **Dynamik:** Endgame-Krisen sind schneller und aggressiver.
*   **Kaskaden:** Nicht gelöste Krisen ziehen oft Folge-Krisen nach sich.

### 5. Prinzipien der Erfolgsbewertung (Scoring)
Der Score einer Stage bemisst sich an der **Effizienz der Leitung**.
*   **Clan-Phase (Stage 0-3):** Hoher Fokus auf Klick-Geschwindigkeit (Manuelle Arbeit).
*   **Gemeinde-Phase (Stage 4-10):** Balance zwischen Klicks und Zeit (Erste Delegation).
*   **Bewegungs-/Global-Phase (Stage 11+):** Fokus fast rein auf Zeit-Effizienz. Klicks sind hier ein Zeichen für *mangelnde* Delegation und sollten den Score nicht mehr massiv beeinflussen.
*   **Benchmark:** Die Zeit-Erwartung wächst nicht-linear mit der Komplexität der Stage-Tasks.

---

## 🏗 Struktur der Schwellen & Fokus-Phasen

| Phase | Stufe | Leitungs-Modus | Mechanik-Fokus |
|-------|-------|----------------|----------------|
| **Clan** | 0-3 | **Macher** | Monolithische Tasks |
| **Gemeinde** | 4-10 | **Leiter** | Task-Chaining & Delegation |
| **Bewegung**| 11-20 | **Stratege** | Auto-Execution & Netzwerke |
| **Global** | 21-32 | **Visionär** | Globale Multiplikation |
