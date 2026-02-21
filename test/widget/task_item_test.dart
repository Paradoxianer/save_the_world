import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/task.item.dart';

/// Ein Mock-TickerProvider, der keine echten Ticks im System registriert.
/// Dies verhindert die "Animation still running" Fehler in Widget-Tests.
class MockTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

void main() {
  // Mock Platform Channels global
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel('plugins.flutter.io/path_provider')
      .setMockMethodCallHandler((methodCall) async => ".");

  group('TaskItem Widget Tests', () {
    setUp(() {
      // ARCHITEKTUR-HACK: Wir tauschen den Taktgeber aus, BEVOR das Game startet.
      // So hat der globale Game-Loop keine Chance, das Test-Framework zu stören.
      Game.tick = MockTickerProvider();
      
      if (Game.mInstance != null) {
        Game.mInstance!.dispose();
      }
      Game.mInstance = null;
      
      final game = Game.getInstance();
      game.isLoading = true; 

      Game.ressources.clear();
      Game.ressources["Money"] = Money(value: 100.0);
      Game.notifier = ChangeNotifier();
      Game.stagenNotifier = ChangeNotifier();
    });

    tearDown(() {
      if (Game.mInstance != null) {
        Game.mInstance!.dispose();
      }
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
      
      // WICHTIG: Animation im Test beenden
      task.controller.stop();
    });
  });
}
