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

### 3. Krisen-Management (Rote Tasks)
Krisen-Tasks dienen als Stress-Test für die Organisation.
*   **Selbstreinigungs-Regel:** Krisentasks müssen sich nach Abschluss (Erfolg ODER Misserfolg) immer selbst aus der Taskliste entfernen (`RemoveTask`). Eine gelöste Krise darf die Liste nicht weiter blockieren.
*   **Dynamik:** Während sie am Anfang langsam sind, werden sie im Endgame schneller und erfordern entweder schnelle Reaktion oder automatisierte Abwehrsysteme.
*   **Nicht geklöste Kriesen** ziehen meist weiter Kriesen nach sich

### 4. Ressourcen-Hürden
Meilenstein-Tasks (`isMilestone: true`) fordern signifikante Kosten in den Ressourcen, die für die aktuelle Phase kritisch sind (Einstieg: Time/Faith; Aufbau: Money/Wisdom; Global: Publicity/Influence).

---

## 🏗 Struktur der Schwellen & Fokus-Phasen

| Phase | Stufe | Leitungs-Modus | Mechanik-Fokus |
|-------|-------|----------------|----------------|
| **Clan** | 0-3 | **Macher** | Monolithische Tasks |
| **Gemeinde** | 4-10 | **Leiter** | Task-Chaining & Delegation |
| **Bewegung**| 11-20 | **Stratege** | Auto-Execution & Netzwerke |
| **Global** | 21-32 | **Visionär** | Globale Multiplikation |

---

## ⚖️ Gameplay-Regel: Der "Meilenstein-Abschluss"
1.  Sobald ein `isMilestone` Task das Limit erhöht hat, muss er sich selbst entfernen (`RemoveTask`).
2.  Er wird durch eine "Standard-Version" ersetzt (Wartung des Status Quo), die keine Gold-Markierung mehr hat und weniger Ressourcen-Impact erzeugt. Dies lenkt den Fokus visuell auf die nächste Wachstumsschwelle.
