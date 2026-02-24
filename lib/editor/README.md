# 🛡️ Stage Architect - Dokumentation

## Übersicht
Der **Stage Architect** ist ein leistungsstarkes Developer-Tool innerhalb des "Save the World"-Projekts. Er wurde entwickelt, um das Entwerfen, Balancen und Exportieren von Spiel-Stages intuitiv und visuell zu ermöglichen, ohne direkt im Quellcode arbeiten zu müssen.

## Kern-Features (Status V4.4)

### 1. Visual Logic Board (Dashboard)
Das Herzstück des Editors ist das Board mit vier funktionalen Zonen:
*   **LIBRARY (COMMON):** Zugriff auf globale Basis-Aufgaben aus der `common_tasks.dart`.
*   **START SETUP:** Aufgaben, die beim Betreten der Stage sofort aktiv sind (`activeTasks`).
*   **RANDOM EVENTS:** Aufgaben, die vom Zufalls-Ticker eingespielt werden (`randomTasks`).
*   **ALL STAGE TASKS:** Die Gesamtliste aller in der Stage definierten Aufgaben.

### 2. Drag & Drop Workflow
*   **Instant Drag:** Schnelles Verschieben von Tasks zwischen den Zonen mittels Drag-Handles (`::`).
*   **Intelligenter Import:** Ziehen aus der Library in die Stage erstellt automatisch eine editierbare Arbeitskopie.
*   **Reverse Drop:** Tasks können aus der Stage zurück in die Library gezogen werden, um sie als globale Vorlagen zu sichern.
*   **Reordering:** Die Reihenfolge innerhalb der Listen bestimmt direkt die Sortierung im Spiel-UI.

### 3. Smart Task Editor (Draft Mode)
*   **Integritätsschutz:** Der Editor nutzt eine Draft-Logik. Alle Änderungen erfolgen in temporären Buffern, um die `final` und `const` Integrität der Spielmodelle nicht zu verletzen.
*   **Visuelles Feedback:** Meilensteine (`isMilestone`) werden im gesamten Board **golden markiert**.
*   **Spielnahe Karten:** Karten zeigen Kosten (Rot, Links), Awards (Grün, Rechts) und Logik-Tags direkt in der Übersicht.

### 4. Deep Modifier System
*   **Rekursive Bearbeitung:** Modifier wie `AutoExecute` erlauben das Hinzufügen und Editieren beliebig vieler Unter-Modifier in einem eigenen Dialog.
*   **Kontext-Dropdowns:** Keine manuellen Texteingaben für Task-Referenzen. Das System bietet Dropdowns aller bekannten Tasks an.
*   **Online Modifier:** Volle Unterstützung für die `online`-Liste (Effekte beim Erscheinen des Tasks).
*   **Standardisierung:** Alle Modifier nutzen einheitlich den `nameOfTask` Standard.

### 5. Professioneller Dart-Export
*   **Stage Export:** Generiert den vollständigen Code für eine `stage_X.dart` inklusive aller Imports, Ressourcen-Konstruktoren und komplexer Modifier-Ketten.
*   **Library Export:** Ein dedizierter Export für die `common_tasks.dart` erlaubt das dauerhafte Speichern neu entworfener Basis-Aufgaben.
*   **Ressourcen-Logik:** Unterstützt multiplikative Abhängigkeiten (z.B. `Money` skaliert mit `Member`).

## Bedienung
Starte den Architect mit folgendem Befehl:
```bash
flutter run -t lib/editor_main.dart -d windows
```

## Architektur-Entscheidungen (ADR)
*   **Modell-Integrität:** Felder in `Task` und `Modifier` bleiben `final`. Der Editor nutzt das "Re-instantiation Pattern" (Neuerstellung bei Änderung).
*   **Mutable State:** Um `UnmodifiableListError` zu vermeiden, arbeitet der Editor ausschließlich auf tiefen Kopien der Stage-Listen.
*   **Typo-Integrität:** Der Editor unterstützt explizit die bestehenden Klassennamen (z.B. `RemoveModifer` ohne 'i'), um Breaking Changes im Hauptspiel zu vermeiden.
