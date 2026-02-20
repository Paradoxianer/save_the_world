import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/task.item.dart';

void main() {
  group('TaskItem Widget Tests', () {
    late Game game;

    setUp(() {
      // Reset Game Singleton
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = false;
      
      // Setup default resources
      Game.ressources["Money"] = Money(value: 100.0);
    });

    testWidgets('TaskItem displays lock icon when disabled', (WidgetTester tester) async {
      final task = Task(name: "Locked Task", enabled: false);
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TaskItem(task: task),
        ),
      ));

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.text("LOCKED TASK"), findsOneWidget);
    });

    testWidgets('TaskItem starts animation on tap when affordable', (WidgetTester tester) async {
      final task = Task(
        name: "Buy Bible", 
        cost: [Money(value: 10.0)],
        duration: 1000,
      );
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TaskItem(task: task),
        ),
      ));

      // Initial state: not animating
      expect(task.controller.isAnimating, isFalse);

      // Tap the task
      await tester.tap(find.byType(TaskItem));
      await tester.pump();

      expect(task.controller.isAnimating, isTrue, reason: "Task should start animating after tap");
      expect(Game.ressources["Money"]?.value, 90.0, reason: "Cost should be subtracted immediately");
    });

    testWidgets('TaskItem is greyed out (opacity) when unaffordable', (WidgetTester tester) async {
      final task = Task(
        name: "Expensive Task", 
        cost: [Money(value: 500.0)],
      );
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TaskItem(task: task),
        ),
      ));

      final opacityWidget = tester.widget<Opacity>(
        find.descendant(
          of: find.byType(TaskItem),
          matching: find.byType(Opacity),
        ).first,
      );

      expect(opacityWidget.opacity, 0.5, reason: "Widget should be semi-transparent when unaffordable");
    });
  });
}
