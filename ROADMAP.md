# 🗺 Save the World - Strategische Roadmap

## 🛠 Phase 1: Der Weg zur Beta (Erledigt)
- [x] **Migration & Stabilität:** Flutter 3 & Null Safety.
- [x] **Modularisierung:** 33 Stages in eigene Module ausgelagert.
- [x] **Web-Enablement:** Stabiler DataManager für Browser-Support.

## 🚀 Phase 2: Game Logic & Juice (Erledigt)
- [x] **Visual Juice:** Wavy Progress, Floating Numbers, Haptic Bounce.
- [x] **Debug Tools:** Stage-Jump Logik für Testing integriert.
- [x] **Active Time Tracking:** Präzise Zeitmessung implementiert.

## 🏁 Phase 3: Release 1 (R1 - Der Weg in den Store)
*Ziel: Ein stabiles, getestetes und poliertes Produkt für den ersten öffentlichen Release.*

### 3.1 Visual & Logic Polish (Erledigt)
- [x] **Comic Dialog System:** Einheitliche Popups (#51).
- [x] **Immersive Onboarding:** Story-Intro (Heilsarmee-Kontext) (#41).
- [x] **Visual Celebration:** Konfetti & elastische Level-Ups (#42).
- [x] **Smart Award System:** Dynamische Berechnung im Modell (#55).
- [x] **Logic Stability:** Fix von Race Conditions & Startup-Bugs (#47).

### 3.2 Qualitätssicherung (Testing)
- [x] **Unit Tests (Core Logik):** Ressourcen-Mathematik, Modifier-Chains und NumberFormatter (Mrd/Bio).
- [x] **Widget Tests (UI Reaktivität):** Validierung von TaskItems, Resource-Feedback und allen Dialogen.
- [ ] **Integration & Simulation (In Arbeit):**
    - [ ] `app_test.dart`: Automatisierter Onboarding-Flow (Fixing: Ticker-Leaks & Timing).
    - [ ] `game_simulation_test.dart`: Headless Balancing Bot (Fixing: Ressourcen-Lock Erkennung).

### 3.3 Beta-Phase & Vorbereitung
- [ ] **Performance Profiling:** Optimierung der Ressourcenlast (insb. Ticker-Logik).
- [ ] **Balancing Fine-tuning:** Auswertung der Simulator-Daten zur Optimierung der Stage-Kurve.
- [ ] **Store Setup:** Einrichtung von Google Play Console & Apple App Store Connect.
- [ ] **CI/CD:** Automatisierte Build-Erstellung für TestFlight & Google Play Beta.

### 3.4 Finalisierung & Launch
- [ ] **Store Assets:** Professionelle Screenshots, Icons und App-Beschreibungen.
- [ ] **Compliance Finalisierung:** Rechtliche Texte & Altersfreigabe.
- [ ] **Production Build:** Erstellung und Einreichung des Release-Builds.

## 🌎 Phase 4: Release 2 (R2 - Ecosystem & Erweiterung)
- [ ] **Audio Engine:** Soundeffekte & Soundtrack (ohne Player-Interferenz) (#56).
- [ ] **Internationalisierung:** Umstellung auf ARB für Multi-Language Support (#38).
- [ ] **Trophy System:** Bronze/Silber/Gold Bewertung pro Stage (#42).
- [ ] **Firebase Integration:** Cloud-Saves & Global Scoreboard.
