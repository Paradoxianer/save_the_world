import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/task.item.dart';

void main() {
  // 1. OUT OF THE BOX: Wir simulieren das Dateisystem auf Systemebene.
  // Das eliminiert alle "MissingPluginException" Meldungen im Terminal.
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel('plugins.flutter.io/path_provider')
      .setMockMethodCallHandler((methodCall) async => ".");

  group('TaskItem Widget Tests', () {
    late Game game;

    setUp(() {
      // 2. Singleton-Reset für Isolation
      Game.mInstance?.dispose();
      Game.mInstance = null;
      
      game = Game.getInstance();
      game.isLoading = true; 
      
      // 3. EINGRENZEN: Wir stoppen den Hintergrund-Ticker sofort.
      // Er wird für diesen Widget-Test nicht benötigt und verursacht sonst Leaks.
      game.dispose(); 

      Game.ressources.clear();
      Game.ressources["Money"] = Money(value: 100.0);
      Game.notifier = ChangeNotifier();
      Game.stagenNotifier = ChangeNotifier();
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
      game.allTasks = [task];
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: TaskItem(task: task)),
      ));

      await tester.tap(find.byType(TaskItem));
      
      // 4. PRÄZISION: Wir pumpen nur 100ms, statt unendlich auf "Settle" zu warten.
      // Das verhindert den pumpAndSettle Timeout.
      await tester.pump(const Duration(milliseconds: 100));

      expect(task.controller.isAnimating, isTrue);
      
      // Cleanup
      task.controller.stop();
    });
  });
}
