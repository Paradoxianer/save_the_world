import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/task.info.dart';
import 'package:save_the_world_flutter_app/widgets/comic_panel_dialog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel('plugins.flutter.io/path_provider')
      .setMockMethodCallHandler((methodCall) async => ".");

  group('TaskInfo Dialog Tests', () {
    setUp(() {
      // Singleton-Reset ohne dispose() (da in Implementierung nicht vorhanden)
      Game.mInstance = null;
      
      // Felder initialisieren, die von Widgets erwartet werden
      Game.notifier = ChangeNotifier();
      Game.stagenNotifier = ChangeNotifier();
      Game.ressources.clear();
      Game.ressources["Money"] = Money(value: 100.0);
    });

    testWidgets('Long press shows info dialog and closes correctly', (WidgetTester tester) async {
      final task = Task(name: "Test Task", description: "This is a test description");

      // Wir bauen eine App, die den Dialog direkt triggert (Isolations-Modus)
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => showTaskInfo(context, task),
                child: const Text('SHOW INFO'),
              ),
            ),
          ),
        ),
      ));

      // 1. Dialog öffnen
      await tester.tap(find.text('SHOW INFO'));
      await tester.pump(const Duration(milliseconds: 500));

      // 2. CHECK: Dialog-Präsenz
      final dialogFinder = find.byType(ComicPanelDialog);
      expect(dialogFinder, findsOneWidget);
      
      // Scoping: Name im Header prüfen
      expect(find.descendant(of: dialogFinder, matching: find.text('TEST TASK')), findsOneWidget);

      // 3. SCHLIESSEN
      final buttonFinder = find.descendant(of: dialogFinder, matching: find.text('ALLES KLAR!'));
      await tester.tap(buttonFinder);
      
      // Genug Zeit zum Ausfaden geben (manuelle Zeit-Steuerung)
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1)); 

      // 4. FINALER CHECK: Dialog muss weg sein
      expect(find.byType(ComicPanelDialog), findsNothing);
    });
  });
}
