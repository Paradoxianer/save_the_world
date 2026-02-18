# 🎨 Design & UI/UX Guide - Save the World

## 🌟 Vision: "The Vibrant Living Cartoon"
Das Spiel muss sich wie ein High-Energy Comic anfühlen. Grelle Farben, Tiefe durch Outlines und eine lebendige Umgebung töten die "Business-Nüchternheit".

## 🛠 Visuelle Prinzipien
* **Cartoon Punch:** Dicke schwarze Outlines (1.5 - 2.0), kräftige Primärfarben, dynamisches Cel-Shading.
* **Environment Immersion:** Jede Stage ist ein Ort, keine Liste.
* **High Contrast:** Gameplay-Elemente müssen vor dem Hintergrund "poppen".

## 🚀 "Juice" & Feedback Roadmap

### 1. Liquid Progress & Feedback (Erledigt)
* Wavy Progress Fill (Normal/Krise/Gold).
* Reaktive Floating Resource Numbers an der AppBar.
* Haptischer Bounce-Effekt beim Task-Klick.

### 2. Gamified Information
* **Resource Tooltips:** Klick auf Ressourcen in der AppBar zeigt Details (Min/Max, Info) im Cartoon-Popup.
* **Stufen-Review:** Klick auf abgeschlossene Stufen in der Liste öffnet Rückblick-Dialog mit alten Aufgaben.
* **Enhanced Level Cards:** Anzeige von `Zeit`, `Klicks` und `Score` direkt auf den Karten in der Stufenliste.

### 3. Visual Celebration
* **Confetti/Fireworks:** Bei Level-Aufstieg wird der Dialog von Partikeleffekten begleitet.
* **Trophy System:** Score-basierte Bewertung (Bronze/Silber/Gold) pro Stage.

### 4. Onboarding & Compliance
* **DSGVO Start:** Zwingende Anzeige des DSGVO-Dialogs beim ersten App-Start.
* **Story Intro:** Kurzer, knackiger Comic-Dialog am Anfang: "Das Ziel: Rette Seelen, vergrößere die Gemeinde!"
* **Cartoon About:** Überarbeitung des Info-Dialogs im Comic-Stil inkl. dynamischer Versionsnummer.

## 📐 Technische Roadmap
1. **Score Engine:** Implementierung der Berechnungslogik für Stage-Performance.
2. **Partikel-System:** Integration eines einfachen Konfetti-Widgets (z.B. `confetti` package).
3. **Onboarding Flow:** Steuerung der Initial-Dialoge in `main.dart`.
4. **Balancing:** Entschärfung der Krisenfrequenz in Stage 1.
