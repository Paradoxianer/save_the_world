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

## 🔥 ✨ #51: UI: Standardize all Dialogs to 'Comic Panel' Style [enhancement, ui, prio: 1-high]
---
**Status / Description:**
Unify the design of resource popups, task info, and level details. Use 3.0 width borders, color-coded headers, and stylized buttons.

---

## ⚡ #29: Logic: Stage-Fallback bei Ressourcenverlust [balancing, prio: 2-medium]
---
**Status / Description:**
Prüfung, ob ein Zurückfallen in eine niedrigere Stufe sinnvoll ist.

**Szenario:**
- Durch 'Streit' sinkt die Mitgliederzahl unter die Schwelle der aktuellen Stufe.
- Konsequenzen für Status und Aufgaben-Pool definieren.

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

## ⚡ ✨ #44: UX: Comic-style About Dialog with dynamic Version [enhancement, ui, prio: 2-medium]
---
**Status / Description:**
Redesign the Info/About dialog to match the 'Living Cartoon' look. Display the current app version read from package_info.

---

## ⚡ #24: Logic: Jüngerschafts- & Wachstumslogik (nach Samy El-Daour) [documentation, balancing, prio: 2-medium]
---
**Status / Description:**
Jüngerschafts-Logik in Stage 4 implementiert:
- Task '1-zu-1 Mentoring' als Basis für Leiterentwicklung.
- Task 'Aufgaben abgeben' generiert nun Zeit-Ressourcen


---

## ☕ #2: Assets: Icon Credits integrieren [documentation, prio: 3-low]
---
**Status / Description:**
Credits aus globals.dart in ein About-Menü überführen.

---

## ☕ #9: Code Cleanup: Mock-Data verschieben [refactor, prio: 3-low]
---
**Status / Description:**
testTasks aus der Produktionslogik in eine dedizierte Mock-Klasse verschieben.

---

## ☕ #7: Balancing: Task-Werte [balancing, prio: 3-low]
---
**Status / Description:**
Rebalancing der Kosten/Nutzen-Rechnung (z.B. studieren vs. Kasse führen).

---

## #56: ⚡ Assets: App Icon & Audio Interference
---
**Status / Description:**
1. App Icon ist noch Standard (Asset-Check). 2. Bug: YouTube Music pausiert, wenn App aktiv ist. Prüfung auf AudioFocus-Anfragen oder zu hohe Ressourcenlast.

---

## #54: ⚡ Logic: Task Enable/Disable System
---
**Status / Description:**
Einführung von 'enabled' (bool) im Task-Modell. Neue Modifier: EnableTask('Name') und DisableTask('Name'). Dies löst auch die Race Condition in Stage 0, indem Tutorial-Tasks explizit deaktiviert werden können.

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

