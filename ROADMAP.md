# 🗺 Save the World - Roadmap zur Beta-Phase

Diese Roadmap skizziert den Weg von der aktuellen Prototyp-Phase bis hin zu einer stabilen, spaßigen Beta-Version.

## Phase 1: Fundament & Stabilität (Alpha)
*Ziel: Ein fehlerfreies Grundgerüst.*

- [ ] **Task-Management Fixes:** Implementierung der Prüfung, ob ein Task bereits läuft, bevor er manipuliert wird (Ref: `game.ressource.model.dart`).
- [ ] **Game Loop Aktivierung:** Die `updateGame` Methode im `Game`-Model mit Leben füllen (periodische Ressourcen-Berechnung, Event-Trigger).
- [ ] **Persistenz-Check:** Validierung des Save/Load-Systems für komplexe Task-Ketten und Modifikatoren.

## Phase 2: Gameplay-Tiefe & Progression (Pre-Beta)
*Ziel: Langzeitmotivation durch funktionierende Spielstufen.*

- [ ] **Stage-System Integration:** Dynamische Freischaltung von Tasks basierend auf der aktuellen Stufe (von "Hausgemeinde" bis "Weltkirche").
- [ ] **Ressourcen-Balancing:** Feinabstimmung der Kosten/Nutzen-Rechnung (z.B. "studieren" vs. "Wirtschaftsmission").
- [ ] **Event-Chains:** Ausbau der Modifikatoren für komplexere Story-Verläufe (z.B. Konsequenzen bei unbezahlten Rechnungen).

## Phase 3: Visuals & "Juice" (Beta-Release)
*Ziel: Den "Spaßfaktor" gemäß rules.md erhöhen.*

- [ ] **Animations-Update:** Visuelle Rückmeldung bei Task-Abschluss oder Verfehlen (Partikeleffekte, Farbumschläge).
- [ ] **UI-Overhaul:** Überarbeitung der `RessourceTable` und `TaskList` für ein immersiveres Spielerlebnis.
- [ ] **Sound-Support:** Implementierung von Audio-Feedback für wichtige Spielereignisse.

## Phase 4: Content-Expansion
*Ziel: Vielfalt und Wiederspielwert.*

- [ ] **Zusätzliche Tasks:** Implementierung weiterer Missionen für höhere Stages.
- [ ] **Achievements:** Belohnungssystem für besondere Meilensteine in der Weltrettung.
