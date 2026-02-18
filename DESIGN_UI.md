# 🎨 Design & UI/UX Guide - Save the World

## 🌟 Vision: "The Vibrant Living Cartoon"
Ein haptisches, farbenfrohes Comic-Erlebnis. Jedes UI-Element atmet, reagiert und fühlt sich wie ein Teil einer interaktiven Welt an.

## 🛠 Visuelle Prinzipien
* **Cartoon Aesthetics:** Dicke schwarze Konturen (Border: 3.0), kräftige Farben, "Bouncy" Animationen.
* **Consistent Dialogs:** Einheitliches "Comic Panel" Design für alle Popups.
* **Information Hierarchy:** Klare Farbcodes für Informationstypen.

## 🚀 "Juice" & Feedback Roadmap (Phase 3)

### 1. The Comic Dialog Standard (High Priority)
* **Visual:** Weißer Hintergrund, abgerundete Ecken (24), dicke schwarze Umrandung (3.0), Offset-Schatten (6, 6).
* **Header:** Farbiges Kopf-Panel (Full width) mit weißem Text in Großbuchstaben.
* **Colors:** 
    * `BlueAccent`: Allgemeine Info (Level Review).
    * `Orange`: Ressourcen & Gameplay.
    * `Amber/Gold`: Meilensteine & Erfolge.
    * `RedAccent`: Krisen & Warnungen.
* **Buttons:** Breite `ElevatedButtons` mit schwarzer Kontur und fetter Typografie.

### 2. Enhanced Statistics & Scoring
* **Score-Visualisierung:** Anzeige von `Score`, `Zeit` und `Klicks` im CelebrationDialog und in der LevelList.
* **Trophy System:** Bronze/Silber/Gold Bewertung pro Stage (Vorbereitung für R2).

### 3. Onboarding Experience
* **Mandatory Flow:** DSGVO -> Story Intro (Goal Explanation).
* **Comic Story Dialogs:** Stylische Einführung in die Welt von 'Save the World'.

## 📐 Technische Roadmap
1. **Dialog Refactoring:** Vereinheitlichung von `RessourceItem`, `TaskInfo` und `LevelList` Dialogen.
2. **Onboarding Controller:** Steuerung der Startsequenz in `main.dart`.
3. **NumberFormatter Localization:** Umstellung auf deutsche Suffixe (Mrd statt B).
