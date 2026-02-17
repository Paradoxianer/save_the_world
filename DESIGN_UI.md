# 🎨 Design & UI/UX Guide - Save the World

## 🌟 Vision
Das Spiel soll sich "lebendig" und "reaktiv" anfühlen. Jede Aktion des Spielers (Klick, Task-Start, Level-Up) muss ein sofortiges, befriedigendes visuelles Feedback erzeugen ("Juice").

## 🛠 Visuelle Prinzipien
* **Reaktivität:** Keine Aktion ohne Reaktion.
* **Konsistenz:** Gleiche Aktionen (z.B. Ressourcenabzug) nutzen immer das gleiche Animationsmuster.
* **Leichtigkeit:** Animationen dürfen den Spielfluss nicht blockieren (non-blocking).

## 🚀 Geplante "Juice" Features (Issue #6)

### 1. Ressourcen-Feedback (Floating Indicators)
* **Trigger:** Wenn ein Task gestartet wird und Ressourcen abgezogen werden.
* **Effekt:** Kleine, halbtransparente Texte (z.B. "-10 💰") schweben vom Ressourcen-Icon nach oben und verblassen.
* **Farben:** Rot für Abzug, Grün für Gewinn.

### 2. Task-Interaktion
* **Haptik:** Kurzes "Skalieren" (Bounce-Effekt) beim Antippen eines Tasks.
* **Progress:** Sanftere Übergänge der Fortschrittsbalken (Curved Animations).

### 3. Stage-Celebration (Erweitert)
* **Partikel:** Konfetti-Effekt oder Lichtstrahlen hinter dem Award-Icon im `CelebrationDialog`.
* **Sound-Visualisierung:** Visuelle Wellenformen, wenn später Sound implementiert wird.

### 4. Click-Feedback
* **Ripple-Effekt:** Optimierung der Material-Ripples bei Buttons.
* **Micro-Animations:** Das Ressourcen-Icon in der AppBar wackelt kurz ("Shake"), wenn es angeklickt wird.

## 📐 Technische Umsetzung (Flutter)
* **Animations-Engine:** Primär `ImplicitlyAnimatedWidgets` für einfache Übergänge.
* **Custom Painter:** Für Partikel-Effekte oder komplexe Floating-Texte, um die Performance hochzuhalten.
* **Overlay:** Floating Indicators werden über ein `OverlayEntry` oder einen lokalen `Stack` in der `AppBar` realisiert.
