# 🎨 Design & UI/UX Guide - Save the World

## 🌟 Vision: "The Vibrant Living Cartoon"
Das Spiel muss sich wie ein High-Energy Comic anfühlen. Weg mit der Business-Nüchternheit, her mit grellen Farben, Tiefe und einer lebendigen Umgebung.

## 🛠 Visuelle Prinzipien
* **Cartoon Punch:** Dicke schwarze Outlines (2.0+), kräftige Primärfarben, dynamische Schatten.
* **Environment Immersion:** Der Spieler befindet sich nicht in einer Liste, sondern an einem Ort (Stage Backgrounds).
* **High Contrast:** Wichtige Gameplay-Elemente (Tasks, Ressourcen) müssen vor dem Hintergrund "poppen".

## 🚀 "Juice" & Environment Roadmap

### 1. Stage Environment System (High Priority)
* **Konzept:** Jede Stage hat ein individuelles Background-Asset.
* **Visual:** Sanfter Cross-Fade beim Stufenaufstieg. Die Umgebung wächst mit der Gemeinde mit.
* **Asset-Typ:** Cartoon-Illustrationen (z.B. SVG oder hochauflösende PNGs).

### 2. Vibrant UI Panels
* **Main Background:** Statt F5F5F5 nutzen wir lebendige Themenfarben pro Stage-Gruppe (z.B. Tutorial = Warmes Gelb, Wachstum = Frisches Grün).
* **Panel Texture:** Einsatz von dezenten Mustern (z.B. Comic-Dots/Halftone) auf Dialog-Hintergründen.

### 3. Wavy Liquid Progress & Feedback (Erledigt)
* Bi-direktionale Wellen-Füllung (Gold für Milestones).
* Reaktives Floating Feedback an allen Ressourcen.

### 4. Interactive Hall of Fame (Erledigt)
* Stilisierte Level-Übersicht mit Rückblick-Funktion.

## 📐 Technische Roadmap (Next)
1. **Background-Controller:** Implementierung eines Widgets, das basierend auf `game.stage` den Hintergrund wechselt.
2. **Stage Model Update:** Hinzufügen von `String backgroundAsset` zu jeder Stage-Definition.
3. **Color Theme Sync:** Dynamische Anpassung der Scaffold-Farbe an die aktuelle Stufe.
