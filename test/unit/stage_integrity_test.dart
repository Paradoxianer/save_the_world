import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/AddToRandom.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/starttaks.model.dart';
import 'package:save_the_world_flutter_app/models/stoptaks.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/task_activation.modifier.dart';
import 'package:save_the_world_flutter_app/stages.dart';

/// Stage-Integritäts-Check: Das Sicherheitsnetz für den Task-Listen-Bau.
///
/// Prüft für JEDE Stage automatisch:
/// 1. Alle Stages sind registriert (allStages deckt alle Levels ab).
/// 2. Keine doppelten Task-Namen innerhalb einer Stage.
/// 3. activeTasks & randomTasks verweisen auf existierende Tasks.
/// 4. Jede Task-Chain (AddTask/RemoveTask/Start/Stop/Enable/Disable) verweist
///    auf einen Task, der in DERSELBEN Stage in allTasks liegt - denn
///    Game.getTask() sucht nur in der aktuellen Stage!
/// 5. Jede Stage (außer der letzten) hat genau einen Gatekeeper
///    (isMilestone-Task), der das Mitglieder-Limit per SetMax anhebt.
/// 6. Jeder Task ist erreichbar (aktiv, random oder per Chain erreichbar).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Extrahiert alle Task-Namen, auf die ein Modifier verweist.
  List<String> referencedTasks(List<Modifier> modifiers) {
    final List<String> names = [];
    for (final m in modifiers) {
      if (m is AddTask) names.add(m.nameOfTask);
      if (m is RemoveTask) names.add(m.nameOfTask);
      if (m is StartTask) names.add(m.nameOfTask);
      if (m is StopTask) names.add(m.nameOfTask);
      if (m is AddToRandom) names.add(m.nameOfTask);
      if (m is EnableTaskModifier) names.add(m.taskName);
      if (m is DisableTaskModifier) names.add(m.taskName);
    }
    return names;
  }

  /// Alle Modifier-Listen eines Tasks (Abschluss, verpasst, eingeblendet).
  List<Modifier> allModifiers(Task t) =>
      [...t.myModifier, ...t.missed, ...t.online];

  group('Stage-Registrierung', () {
    test('Alle Levels haben eine registrierte Stage', () {
      expect(
        allStages.length,
        levels.length,
        reason:
            'globals.dart definiert ${levels.length} Levels, aber stages.dart '
            'registriert nur ${allStages.length} Stages. Fehlende Stages führen '
            'zu einem Crash (RangeError) beim Levelaufstieg!',
      );
    });

    test('Stage-Level sind lückenlos und passen zum Index', () {
      for (int i = 0; i < allStages.length; i++) {
        expect(allStages[i].level, i,
            reason: 'allStages[$i] hat level ${allStages[i].level}.');
      }
    });

    test('Stage.member entspricht der Level-Schwelle aus globals.dart', () {
      final thresholds = levels.keys.toList();
      for (int i = 0; i < allStages.length; i++) {
        expect(allStages[i].member, thresholds[i],
            reason:
                'Stage $i: member=${allStages[i].member}, Schwelle laut '
                'globals.dart ist aber ${thresholds[i]}.');
      }
    });
  });

  group('Task-Chain Integrität (pro Stage)', () {
    for (final Stage stage in allStages) {
      test('Stage ${stage.level}: ${stage.description}', () {
        final Set<String> taskNames = {};
        final List<String> errors = [];

        // 1. Doppelte Task-Namen
        for (final t in stage.allTasks) {
          if (!taskNames.add(t.name)) {
            errors.add("Doppelter Task-Name: '${t.name}'");
          }
        }

        // 2. activeTasks & randomTasks müssen existieren
        for (final name in stage.activeTasks) {
          if (!taskNames.contains(name)) {
            errors.add("activeTasks verweist auf unbekannten Task: '$name'");
          }
        }
        for (final name in stage.randomTasks) {
          if (!taskNames.contains(name)) {
            errors.add("randomTasks verweist auf unbekannten Task: '$name'");
          }
        }

        // 3. Alle Chain-Verweise müssen in DIESER Stage auflösbar sein
        for (final t in stage.allTasks) {
          for (final ref in referencedTasks(allModifiers(t))) {
            if (!taskNames.contains(ref)) {
              errors.add(
                  "Task '${t.name}' verweist auf '$ref' - existiert nicht in "
                  "allTasks von Stage ${stage.level} (Chain bricht ab!)");
            }
          }
        }

        // 4. Erreichbarkeit: aktiv, random oder Ziel eines AddTask.
        // NUR EINE WARNUNG: Aktive Tasks werden beim Stufenaufstieg mitgenommen
        // (z.B. bleibt "Kollekte" aus einer früheren Stage aktiv). Ein hier
        // unerreichbarer Task kann im echten Spiel also trotzdem verfügbar sein.
        final Set<String> reachable = {
          ...stage.activeTasks,
          ...stage.randomTasks,
        };
        for (final t in stage.allTasks) {
          for (final m in allModifiers(t)) {
            if (m is AddTask) reachable.add(m.nameOfTask);
            if (m is AddToRandom) reachable.add(m.nameOfTask);
          }
        }
        for (final t in stage.allTasks) {
          if (!reachable.contains(t.name)) {
            // ignore: avoid_print
            print("WARNUNG Stage ${stage.level}: Task '${t.name}' ist in "
                "dieser Stage weder aktiv, random, noch Ziel eines AddTask "
                "(evtl. nur per Carryover aus früherer Stage erreichbar).");
          }
        }

        expect(errors, isEmpty,
            reason: 'Stage ${stage.level}:\n  ${errors.join("\n  ")}');
      });
    }
  });

  group('Gatekeeper (Meilensteine)', () {
    test('Jede Stage außer der letzten hat genau einen Gatekeeper mit SetMax',
        () {
      final thresholds = levels.keys.toList();
      final List<String> errors = [];

      for (final Stage stage in allStages) {
        final milestones =
            stage.allTasks.where((t) => t.isMilestone).toList();

        if (milestones.length != 1) {
          errors.add(
              'Stage ${stage.level}: ${milestones.length} Meilenstein-Tasks '
              'gefunden (erwartet: genau 1).');
          continue;
        }

        final gatekeeper = milestones.first;

        // Gatekeeper müssen Einmal-Aufgaben sein (Default über isMilestone).
        if (!gatekeeper.once) {
          errors.add(
              "Stage ${stage.level}: Gatekeeper '${gatekeeper.name}' ist "
              'nicht als once markiert.');
        }

        // Der Gatekeeper MUSS in seiner eigenen Stage erreichbar sein -
        // Carryover hilft hier nicht, denn er existiert in keiner früheren
        // Stage. Ohne ihn bleibt das Member-Limit stehen: harte Sackgasse.
        final Set<String> reachable = {
          ...stage.activeTasks,
          ...stage.randomTasks,
        };
        for (final t in stage.allTasks) {
          for (final m in allModifiers(t)) {
            if (m is AddTask) reachable.add(m.nameOfTask);
          }
        }
        if (!reachable.contains(gatekeeper.name)) {
          errors.add(
              "Stage ${stage.level}: Gatekeeper '${gatekeeper.name}' ist "
              'unerreichbar (weder aktiv, random, noch Ziel eines AddTask) - '
              'der Levelaufstieg ist blockiert!');
        }

        // Der Gatekeeper muss das Member-Limit auf die nächste Schwelle heben.
        if (stage.level < allStages.length - 1) {
          final setMax = allModifiers(gatekeeper)
              .whereType<SetMax>()
              .where((m) => m.workOn == 'Member')
              .toList();
          if (setMax.isEmpty) {
            errors.add(
                "Stage ${stage.level}: Gatekeeper '${gatekeeper.name}' hat "
                'kein SetMax(Member) - Levelaufstieg unmöglich!');
          } else {
            final expected = thresholds[stage.level + 1].toDouble();
            if (setMax.first.newMax != expected) {
              errors.add(
                  "Stage ${stage.level}: Gatekeeper '${gatekeeper.name}' setzt "
                  'Member-Max auf ${setMax.first.newMax}, die nächste '
                  'Level-Schwelle ist aber $expected.');
            }
          }
        }
      }

      expect(errors, isEmpty, reason: '\n  ${errors.join("\n  ")}');
    });
  });

  group('Grundversorgung (Balancing-Minimum)', () {
    test('Jede Stage hat eine Zeit-Regeneration (Schlafen)', () {
      for (final Stage stage in allStages) {
        final hasSleep = stage.allTasks.any((t) => t.name == baseSleep.name);
        expect(hasSleep, isTrue,
            reason:
                'Stage ${stage.level} hat keinen Schlafen-Task - ohne '
                'Zeit-Regeneration kann der Spieler stecken bleiben.');
      }
    });
  });
}
