import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/task.item.dart';

void main() {
  group('TaskInfo Dialog Tests', () {
    setUp(() {
      Game.notifier = ChangeNotifier();
      Game.stagenNotifier = ChangeNotifier();
      Game.ressources.clear();
      Game.ressources["Money"] = Money(value: 100.0);
    });

    testWidgets('Long press on TaskItem shows info dialog', (WidgetTester tester) async {
      final task = Task(
        name: "Test Mission", 
        description: "Save the children",
        cost: [Money(value: 10.0)],
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: TaskItem(task: task)),
      ));

      // 1. Long Press ausführen
      await tester.longPress(find.byType(TaskItem));
      await tester.pumpAndSettle(); // Warten auf Dialog-Animation

      // 2. Prüfen ob Dialog-Inhalte da sind
      expect(find.text('AUFGABEN-DETAILS'), findsOneWidget);
      expect(find.text('SAVE THE CHILDREN'), findsOneWidget);
      
      // 3. Button zum Schließen finden und drücken
      expect(find.text('ALLES KLAR!'), findsOneWidget);
      await tester.tap(find.text('ALLES KLAR!'));
      await tester.pumpAndSettle();

      // 4. Prüfen ob Dialog weg ist
      expect(find.text('AUFGABEN-DETAILS'), findsNothing);
    });
  });
}
