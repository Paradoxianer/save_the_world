# 📋 GitHub Issues Roadmap
_Sortiert nach Priorität (High > Medium > Low)_

## 🔥 #22: UX & Balancing: Der Ruf (Tutorial-Onboarding) [balancing, content, prio: 1-high]
---
**Status / Description:**
Das Onboarding muss den geistlichen Dienst widerspiegeln.

**Phasen:**
1. Stille Zeit (Bibellesen)
2. Gebets-Motor (Beten)
3. Jüngerschaft (Hausbesuche)
4. Zeitmanagement (Schlafen)
5. Gemeinde-Keimzelle (Essen in Wohnung ab 5 Pers.)

**Fokus:** Weg von Organisation (Kasse), hin zur geistlichen Basis.

---

## ⚡ ✨ #6: UI-Feedback: Fehlende Visualisierung bei Kosten [enhancement, ui, prio: 2-medium]
---
**Status / Description:**
Wenn Ressourcen für einen Task abgezogen werden, gibt es kein visuelles Feedback für den Spieler.

---

## ⚡ ✨ #1: Logic: Miss-Mechanik verfeinern [enhancement, prio: 2-medium]
---
**Status / Description:**
Basis-Migration der miss-Logik in den Modifikatoren vorbereitet.

---

## ⚡ #8: UX: Tab-Navigation vervollständigen [ui, prio: 2-medium]
---
**Status / Description:**
Zwei Tabs (TaskList & LevelList) sind aktiv. Prüfung, ob weitere Ansichten für die Beta nötig sind.

---

## ⚡ #24: Logic: Jüngerschafts- & Wachstumslogik (nach Samy El-Daour) [documentation, balancing, prio: 2-medium]
---
**Status / Description:**
Jüngerschafts-Logik in Stage 4 implementiert:
- Task '1-zu-1 Mentoring' als Basis für Leiterentwicklung.
- Task 'Aufgaben abgeben' generiert nun Zeit-Ressourcen


---

## ⚡ #35: Feature: Web Compatibility & Optimization [ui, refactor, prio: 2-medium]
---
**Status / Description:**
Prüfung und Sicherstellung der volle Funktionalität im Browser.

**To-Do:**
- LocalStorage vs. FileSystem (DataManager) für Web anpassen.
- Responsive Layout-Checks (AppBar und Listen).
- Performance-Optimierung für WASM/Skia Renderer.
- Sicherstellen, dass Share-Funktionen im Web korrekt gehandhabt werden (share_plus Fallbacks).

---

## ⚡ #21: UI: Zahlen-Sichtbarkeit & Layout-Verschiebung fixen [ui, prio: 2-medium]
---
**Status / Description:**
Im Web-Build sind die Ressourcen-Zahlen schwer lesbar und das Layout wirkt verschoben. 

**To-Do:**
- Spaltenbreite in `RessourceTable` dynamisch anpassen.
- Kontrast und Schriftgröße der Ressourcen-Werte prüfen.
- Alignment in der AppBar für Web optimieren.

---

## ⚡ #29: Logic: Stage-Fallback bei Ressourcenverlust [balancing, prio: 2-medium]
---
**Status / Description:**
Prüfung, ob ein Zurückfallen in eine niedrigere Stufe sinnvoll ist.

**Szenario:**
- Durch 'Streit' sinkt die Mitgliederzahl unter die Schwelle der aktuellen Stufe.
- Konsequenzen für Status und Aufgaben-Pool definieren.

---

## ☕ #2: Assets: Icon Credits integrieren [documentation, prio: 3-low]
---
**Status / Description:**
Credits aus globals.dart in ein About-Menü überführen.

---

## ☕ #7: Balancing: Task-Werte [balancing, prio: 3-low]
---
**Status / Description:**
Rebalancing der Kosten/Nutzen-Rechnung (z.B. studieren vs. Kasse führen).

---

## ☕ #9: Code Cleanup: Mock-Data verschieben [refactor, prio: 3-low]
---
**Status / Description:**
testTasks aus der Produktionslogik in eine dedizierte Mock-Klasse verschieben.

---

## ☕ ✨ #32: Enhancement: Stage-Fallback System [enhancement, prio: 3-low]
---
**Status / Description:**
Prüfung, ob ein Zurückfallen in eine niedrigere Stufe sinnvoll ist.

**Konsequenz:**
- Bei Unterschreitung der Mitgliederschwelle gehen Aufgaben der höheren Stufe wieder verloren.
- Markiert als Low Priority Enhancement.

---

## ✨ #38: ✨ Feature: Full Internationalization (i18n) Support [enhancement, ui]
---
**Status / Description:**
### Status / Description
Die App unterstützt bereits Locales (DE/EN) in der main.dart, aber viele Inhalte und Logiken sind noch hartkodiert.

### To-Do
- [ ] **Lokalisiertes Zahlenformat:** Der NumberFormatter muss Suffixe (K, M, B) basierend auf der Locale anpassen (z.B. 1.5 Mrd statt 1.5B).
- [ ] **ARB-Dateien:** Extraktion aller Hardcoded Strings (z.B. in MessageModifier oder Task-Beschreibungen) in ARB-Dateien.
- [ ] **Pluralisierung:** Korrekte Handhabung von Ressourcen-Texten (z.B. '1 Mitglied' vs '2 Mitglieder').
- [ ] **intl Package:** Integration des intl Packages in die pubspec.yaml für robuste Formatierung.

---

