# Task-Design: Chains, Gatekeeper & Balancing

Dieses Dokument beschreibt, wie Task-Listen für Stages gebaut werden — mit dem
Ziel, dass **Chains kontrollierbar bleiben** und **Gatekeeper-Aufgaben genau
einmal auftauchen**.

## Das Grundproblem (und seine Lösung)

Früher galt: Wenn Task A per `AddTask` einen Gatekeeper einblendet, dann
blendet A ihn bei *jedem* Abschluss wieder ein — auch nachdem der Gatekeeper
längst erledigt ist. Der einzige Ausweg war, Task A nach dem ersten Durchlauf
durch eine Kopie ohne `AddTask` zu ersetzen (siehe das
`Bibellesen` → `Stille Zeit`-Muster in Stage 0). Das skaliert nicht über 33
Stages.

**Die Lösung ist das `once`-Flag am Task:**

```dart
Task(
  name: "Leiter-Mentoring",
  isMilestone: true,   // => once ist automatisch true
  ...
)
```

Verhalten von `once`-Tasks:

1. **Selbstaufräumend:** Nach dem ersten Abschluss entfernt sich der Task
   selbst aus der aktiven Liste. Ein `RemoveTask(task: <sich selbst>)` im
   Modifier ist nicht mehr nötig (schadet aber auch nicht).
2. **Dauerhaft gesperrt:** Der Name wandert in `Game.completedOnceTasks`
   (wird in `Game.json` gespeichert). `AddTask`, Random-Events und
   `initStage` blenden ihn **nie wieder** ein — egal wie viele Chains auf ihn
   zeigen.
3. **Default:** `once` ist automatisch `true` für `isMilestone`-Tasks und
   `false` für alle anderen. Beides kann explizit überschrieben werden
   (`once: true` für einmalige Tutorial-/Story-Tasks, `once: false` für einen
   theoretisch wiederholbaren Meilenstein).

**Konsequenz für den Stage-Bau:** Chain-Starter dürfen ihren `AddTask` auf den
Gatekeeper einfach behalten und beliebig oft wiederholbar sein. Es braucht
keine Ersatz-Kopien mehr.

## Task-Rollen pro Stage

Jede Stage folgt demselben Bauplan (siehe `stage_4.dart` als Referenz):

| Rolle | Zweck | Eigenschaften |
|---|---|---|
| **Basis** | Ressourcen-Loop (Zeit, Glauben, Geld) | Wiederholbar; `baseSleep`, `baseBible`, `collectMoney` aus `common_tasks.dart` |
| **Chain-Starter** | Führt zum Gatekeeper hin | Wiederholbar, `AddTask` auf nächstes Chain-Glied |
| **Gatekeeper** | Hebt das Member-Limit per `SetMax` auf die nächste Level-Schwelle | `isMilestone: true` (⇒ `once`), teuer, genau **einer pro Stage** |
| **Wartung** | Beschäftigung nach dem Gatekeeper | Wird oft vom Gatekeeper per `AddTask` freigeschaltet |
| **Krise** | Random-Event mit `timeToSolve` | In `randomTasks` eintragen; `missed` bestraft und blendet ggf. neu ein |

## Regeln für Chains

1. **Alles bleibt in der Stage:** `Game.getTask()` sucht nur in `allTasks`
   der *aktuellen* Stage. Jeder Name, auf den ein `AddTask`/`RemoveTask`/…
   zeigt, muss in `allTasks` derselben Stage stehen — sonst bricht die Chain
   beim Levelaufstieg oder sofort still ab.
2. **Ein Gatekeeper pro Stage,** und sein `SetMax(Member)` muss exakt die
   nächste Schwelle aus `levels` (globals.dart) setzen.
3. **Jeder Task muss erreichbar sein:** über `activeTasks`, `randomTasks`
   oder als Ziel eines `AddTask`. Alles andere ist toter Content.
4. **Jede Stage braucht Zeit-Regeneration** (`baseSleep`), sonst kann der
   Spieler in eine Sackgasse laufen.

## Das Sicherheitsnetz: `stage_integrity_test.dart`

Alle Regeln oben werden automatisch geprüft:

```bash
flutter test test/unit/stage_integrity_test.dart
```

Der Test läuft über **alle registrierten Stages** und meldet pro Stage:

- nicht auflösbare Chain-Verweise (Regel 1),
- fehlende/mehrfache Gatekeeper und falsche `SetMax`-Werte (Regel 2),
- unerreichbare Tasks (Regel 3),
- fehlendes `Schlafen` (Regel 4),
- doppelte Task-Namen, kaputte `activeTasks`/`randomTasks`-Einträge,
- fehlende Stage-Registrierungen (`allStages` vs. `levels`).

**Workflow beim Bauen einer neuen Stage:** Stage-Datei schreiben → in
`stages.dart` registrieren → Integrity-Test laufen lassen → Fehlerliste
abarbeiten. Erst danach ins Balancing gehen (`architect_balancing_bot_test`).

## Balancing-Daumenregeln

- Der Gatekeeper soll das *Ziel* der Stage sein: seine Kosten so wählen, dass
  der Spieler mehrere Durchläufe der Basis-/Chain-Tasks braucht.
- Awards der Wartungs-Tasks etwas über den Kosten halten (positiver Loop),
  Krisen als Ressourcen-Senke dagegenhalten.
- `duration`/`timeToSolve` skalieren mit der Stage-Größe (vgl. Stage 29:
  Minuten statt Sekunden).
