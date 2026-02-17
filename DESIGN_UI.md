# 🎨 Design & UI/UX Guide - Save the World

## 🌟 Vision: "The Living Cartoon World"
Ein haptisches, farbenfrohes Comic-Erlebnis, das klare visuelle Sprache für Fortschritt und Kosten nutzt.

## 🛠 Visuelle Prinzipien
* **Cartoon Aesthetics:** Dicke Konturen, Wellen-Elemente statt gerader Linien.
* **Directional Progress:** Fortschrittsrichtung kommuniziert die Art des Tasks.
* **Dual-Point Feedback:** Synchronisierte Animationen an Aktion (Task) und Status (AppBar).

## 🚀 Geplante "Juice" Features

### 1. Wavy Liquid Progress (High Priority)
* **Konzept:** Der Task-Hintergrund füllt sich wie ein Tank.
* **Richtung:** 
    * **Positiv:** Füllt sich von LINKS nach RECHTS (Grün/Blau).
    * **Negativ/Krise:** Füllt sich von RECHTS nach LINKS (Rot).
* **Visual:** Die Trennkante ist eine statische Cartoon-Welle (Bezier-Kurve).

### 2. Twin-Floating-Numbers (Feedback)
* **Trigger:** Bei Ressourcen-Kosten oder Erträgen.
* **Aktion am Task:** Eine kleine rote Zahl (z.B. "-5 💰") schwebt vom Task nach oben und verblasst.
* **Aktion in AppBar:** Zeitgleich schwebt am entsprechenden Ressourcen-Icon eine rote Zahl ("-5") nach oben.
* **Ertrag (Award):** Grüne Zahlen ("+100 👥") an beiden Stellen.

### 3. Stage-Atmosphäre
* Jede Stage nutzt ein spezifisches Cartoon-Hintergrundbild (Cross-Fade beim Wechsel).

## 📐 Technische Roadmap
1. **WavyTaskPainter:** Custom Painter für bi-direktionale Wellen-Füllung.
2. **FeedbackEmitter Service:** Ein einfacher Service, um Overlay-Animationen an Widget-Positionen zu triggern.
3. **Stage-Background System:** Controller-Logik für den Hintergrund-Wechsel.
