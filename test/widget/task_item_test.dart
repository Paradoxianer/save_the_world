import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/task.item.dart';

/// Ein kontrollierter Taktgeber für Tests
class TestTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

void main() {
  group('TaskItem Widget Tests', () {
    late Game game;

    setUp(() {
      // Architektur-Verbesserung nutzen: Test-Ticker injizieren
      Game.tick = TestTickerProvider();
      
      Game.mInstance = null;
      game = Game.getInstance();
      game.isLoading = true; 
      
      // Notwendige Felder initialisieren (Ehemals LateInitializationError)
      Game.notifier = ChangeNotifier();
      Game.stagenNotifier = ChangeNotifier();
      
      Game.ressources.clear();
      Game.ressources["Money"] = Money(value: 100.0);
    });

    tearDown(() {
      // ECHTER FIX: Ressourcen sauber freigeben, um unendliche Ticker zu stoppen
      game.dispose();
      Game.mInstance = null;
    });

    testWidgets('TaskItem displays lock icon when disabled', (WidgetTester tester) async {
      final task = Task(name: "Locked Task", description: "Test", enabled: false);
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: TaskItem(task: task)),
      ));

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.text("LOCKED TASK"), findsOneWidget);
    });

    testWidgets('TaskItem starts animation on tap when affordable', (WidgetTester tester) async {
      final task = Task(
        name: "Buy Bible", 
        description: "Test",
        cost: [Money(value: 10.0)],
        duration: 1000,
      );
      game.allTasks = [task];
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: TaskItem(task: task)),
      ));

      await tester.tap(find.byType(TaskItem));
      await tester.pump(); 

      expect(task.controller.isAnimating, isTrue);
      
      // Cleanup für den Test-Ticker
      task.controller.stop();
    });
  });
}
