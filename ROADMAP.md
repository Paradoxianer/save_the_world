# 🗺 Save the World - Strategische Roadmap

Diese Roadmap beschreibt den Weg vom aktuellen Prototyp zur globalen Version (R2). Sie basiert auf den Wachstums-Schwellen der `CHURCH_GROWTH_LOGIC.md`.

## 🛠 Phase 1: Der Weg zur Beta (Fokus: Fundament & Onboarding)
*Ziel: Ein stabiles, spielbares Tutorial und funktionierende Kern-Mechaniken.*

- [x] **Migration & Stabilität:** Umstellung auf Flutter 3 & Null Safety (Erledigt).
- [x] **Modularisierung (#23):** Auslagerung der 32 Stages in eigene Daten-Module (Erledigt).
- [x] **Apostolisches Onboarding (#22):** Überarbeitung von Stage 0 (Stille Zeit -> Gebet -> Jüngerschaft) (Erledigt).
- [x] **Gatekeeper-System (#33, #30):** Implementierung aktiver Stufenaufstiege via SetMax-Modifier und Gold-Markierung im UI (Erledigt).
- [x] **UI-Synchronisation (#26):** Echtzeit-Updates der Ressourcen-Kosten im Task-UI (Erledigt).
- [x] **Web-Enablement (#37):** Abstrahierter DataManager mit SharedPreferences-Support für plattformunabhängige Speicherung (Erledigt).

## 🚀 Phase 2: Beta-Release (Fokus: Content & Balancing)
*Ziel: Alle 33 Stufen spielbar und motivierend.*

- [x] **Celebration UI (#27):** Überarbeitung des Glückwunsch-Dialogs mit animierter elastischer Anzeige (Erledigt).
- [x] **Adaptive UI (#28):** Automatische Zahlen-Formatierung (1K, 1.5M) via zentralem NumberFormatter (Erledigt).
- [x] **Content-Komplettierung (#15):** Alle 33 Stufen basierend auf der CHURCH_GROWTH_LOGIC finalisiert (Milestone-Ersatz, Krisen-Kaskaden, Pacing) (Erledigt).
- [x] **Persistenz-Check (#5):** Vollständige Serialisierung laufender Tasks inkl. Animationsfortschritt (Erledigt).
- [ ] **Balancing-Feinschliff:** Langzeittest der Ressourcen-Kurven im Mid-Game.

## 🏁 Phase 3: Release 1 (R1 - Polish & Sound)
*Ziel: Ein fertiges Produkt für App-Stores.*

- [ ] **Audio-Feedback:** Implementierung von Soundeffekten für Erfolg und Krise.
- [ ] **Visual "Juice" (#6):** Erweiterte Animationen beim Ressourcenabzug direkt am Icon.
- [ ] **Internationalisierung (#38):** Umstellung auf ARB-Dateien und lokalisierte Zahlenformate.
- [ ] **About & Credits (#2):** Integration der Helfer-Credits und rechtlichen Hinweise.

## 🌎 Phase 4: Release 2 (R2 - Ecosystem)
*Ziel: Globale Vernetzung.*

- [ ] **Firebase Integration (#36):** Cloud-Saves und Synchronisation.
- [ ] **Global Scoreboard (#35):** Internationales Ranking basierend auf Zeit und Effizienz.
- [ ] **Stage-Analytics:** Auswertung der Spielerwege zur Gamedesign-Optimierung.
