# 🛠 Offene Issues für den Beta-Release

Hier sind die kritischen Baustellen, die vor dem Beta-Start behoben werden müssen.

## 🔴 Kritisch (Beta-Blocker)
- [ ] **Bug: `updateGame` ist leer.** Der zentrale Game-Loop berechnet aktuell nichts. Ressourcen-Ticks und zeitgesteuerte Events fehlen.
- [ ] **Validation: Task-Duplikation.** In `addTask` (Game-Model) fehlt die Logik, um zu verhindern, dass der gleiche Task mehrfach gleichzeitig läuft, was die Ressourcen-Logik sprengen könnte.
- [ ] **Data Safety: JSON-Serialisierung.** Die `fromJson` Fabrik in `Game` ist unvollständig (z.B. `Ressource.fromJson` Mapping). Dies führt zu Abstürzen beim Laden alter Spielstände.

## 🟡 Mittel (Gameplay & UI)
- [ ] **UI-Feedback: Fehlende Visualisierung bei Kosten.** Wenn Ressourcen für einen Task abgezogen werden, gibt es kein visuelles Feedback.
- [ ] **Logic: Miss-Mechanik verfeinern.** Die `miss()` Funktion in `Task` gibt aktuell nur einen Print aus. Hier muss ein echtes In-Game-Event (UI-Benachrichtigung) getriggert werden.
- [ ] **Balancing: Task-Werte.** Die Werte für "studieren" (Kosten 200 Money) stehen in keinem Verhältnis zu "Kasse führen" (Ertrag 0.10 Money). Hier ist ein Rebalancing nötig.

## 🟢 Niedrig (Polishing)
- [ ] **UX: Tab-Navigation.** Die `TabBarView` in `main.dart` hat 3 Tabs definiert, zeigt aber aktuell nur die `TaskList` an.
- [ ] **Assets: Icon Credits.** Integration der in `globals.dart` erwähnten Credits in ein "About"-Menü.
- [ ] **Code Cleanup:** Entfernen der `testTasks` aus der Produktionslogik und Verschiebung in eine dedizierte Mock-Data Klasse.
