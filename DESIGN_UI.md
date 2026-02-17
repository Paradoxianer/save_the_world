# 🎨 Design & UI/UX Guide - Save the World

## 🌟 Vision: "The Living Cartoon World"
Ein haptisches, farbenfrohes Comic-Erlebnis. Jedes UI-Element atmet, reagiert und fühlt sich wie ein Teil einer interaktiven Welt an.

## 🛠 Visuelle Prinzipien
* **Cartoon Aesthetics:** Dicke schwarze Konturen (Border), kräftige Farben, "Bouncy" Animationen.
* **Liquid Progress:** Fortschritt fühlt sich organisch an (Wellen-Füllung).
* **Information Hierarchy:** Wichtige Dinge (Milestones) sind Gold und glänzen.

## 🚀 "Juice" Features & Roadmap

### 1. Wavy Liquid Progress (Enhanced)
* **Standard:** Blau/Grün von Links nach Rechts.
* **Krise:** Rot von Rechts nach Links.
* **Milestones (Gold):** Goldene Welle für "Meilenstein"-Aufgaben.
* **Visual:** Trennkante ist eine Bezier-Welle.

### 2. Reactive Floating Feedback
* Jede Änderung an Ressourcen triggert eine schwebende Zahl direkt am AppBar-Icon.
* Synchronisierte Icons und farbliche Kodierung (Rot/Grün).

### 3. Cartoon Interface Components
* **AppBar:** Fette Outlines, Schatten-Effekte, weg vom flachen Material-Look.
* **Dialoge/Info-Boxen:** Task-Details werden in "Comic-Panels" angezeigt (starke Ränder, handgezeichneter Touch).
* **Resource Tooltips:** Klick auf Ressourcen in der AppBar zeigt Details (Min/Max, Info) in einem Cartoon-Popup.

### 4. Stage-Atmosphäre
* Jede Stage nutzt ein spezifisches Cartoon-Hintergrundbild (Cross-Fade beim Wechsel).

## 📐 Technische Roadmap
1. **Milestone Styling:** Update `TaskItem` für goldene Wellen.
2. **Resource Detail Dialog:** Implementierung der Klick-Logik für AppBar-Ressourcen.
3. **AppBar & Info Polishing:** Styling-Update für alle statischen UI-Container.
