import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game_notifier.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/task.item.dart';
import '../helpers/test_storage.dart';

/// Game() startet im Konstruktor einen dauerhaft laufenden Ticker. Flutter
/// prüft direkt am Ende des Testkörpers - also VOR tearDown -, ob noch
/// Animationen laufen ("An animation is still running even after the widget
/// tree was disposed"). Deshalb muss das Spiel am Ende jedes Tests selbst
/// gestoppt werden. (Der frühere MockTickerProvider erzeugte ebenfalls einen
/// echten Ticker und änderte daran nichts.)
void _stopGame() {
  Game.mInstance?.dispose();
  Game.mInstance = null;
}

void main() {
  // Mock Platform Channels global
  useTempDocumentsDirectory();

  group('TaskItem Widget Tests', () {
    setUp(() {
      _stopGame();
      
      final game = Game.getInstance();
      game.isLoading = true; 

      Game.ressources.clear();
      Game.ressources["Money"] = Money(value: 100.0);
      Game.notifier = GameNotifier();
      Game.stagenNotifier = GameNotifier();
    });

    tearDown(_stopGame);

    testWidgets('TaskItem displays lock icon when disabled', (WidgetTester tester) async {
      final task = Task(name: "Locked Task", description: "Test", enabled: false);
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: TaskItem(task: task)),
      ));

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.text("LOCKED TASK"), findsOneWidget);
      _stopGame();
    });

    testWidgets('TaskItem starts animation on tap', (WidgetTester tester) async {
      final task = Task(name: "Test Task", description: "Test", duration: 1000);
      Game.getInstance().allTasks = [task];
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: TaskItem(task: task)),
      ));

      // Wir nutzen runAsync, falls interne Timer gefeuert werden
      await tester.runAsync(() async {
        await tester.tap(find.byType(TaskItem));
        await tester.pump(const Duration(milliseconds: 100));
      });

      expect(task.controller.isAnimating, isTrue);
      
      // WICHTIG: Animationen im Test beenden
      task.controller.stop();
      _stopGame();
    });
  });
}
