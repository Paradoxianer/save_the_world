import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/task.item.dart';

/// Ein TickerProvider für Tests, der alle erzeugten Ticker trackt,
/// damit wir sie am Ende stoppen können, ohne die Game-Klasse zu ändern.
class TrackingTickerProvider implements TickerProvider {
  final List<Ticker> _tickers = [];

  @override
  Ticker createTicker(TickerCallback onTick) {
    final ticker = Ticker(onTick);
    _tickers.add(ticker);
    return ticker;
  }

  void silenceAll() {
    for (var t in _tickers) {
      if (t.isActive) t.stop();
    }
  }
}

void main() {
  group('TaskItem Widget Tests', () {
    late TrackingTickerProvider testTickerProvider;

    setUp(() {
      testTickerProvider = TrackingTickerProvider();
      // Wir injizieren den Test-Ticker-Provider
      Game.tick = testTickerProvider;
      
      // Notwendige Felder initialisieren
      Game.notifier = ChangeNotifier();
      Game.stagenNotifier = ChangeNotifier();
      Game.ressources.clear();
      Game.ressources["Money"] = Money(value: 100.0);
      Game.mInstance = null; // Sicherstellen, dass jeder Test frisch startet
    });

    tearDown(() {
      // Alle Ticker (auch die vom Game-Loop) stoppen
      testTickerProvider.silenceAll();
    });

    testWidgets('TaskItem displays lock icon when disabled', (WidgetTester tester) async {
      final task = Task(name: "Locked Task", description: "Test", enabled: false);
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: TaskItem(task: task)),
      ));

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.text("LOCKED TASK"), findsOneWidget);
    });

    testWidgets('TaskItem starts animation on tap', (WidgetTester tester) async {
      final task = Task(name: "Test Task", description: "Test", duration: 1000);
      // Wir müssen den Task im Game registrieren, damit recordClick() funktioniert
      Game.getInstance().allTasks = [task];
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: TaskItem(task: task)),
      ));

      await tester.tap(find.byType(TaskItem));
      await tester.pump(); // Startet Animation

      expect(task.controller.isAnimating, isTrue);
      
      // WICHTIG: Die interne Click-Animation (60ms) zu Ende laufen lassen
      await tester.pump(const Duration(milliseconds: 100));
      
      // Task-Ticker manuell stoppen für sauberes Test-Ende
      task.controller.stop();
    });
  });
}
