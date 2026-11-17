import 'package:flutter_test/flutter_test.dart';
import 'package:save_the_world_flutter_app/main.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';

import 'helpers/test_storage.dart';

void main() {
  useTempDocumentsDirectory();

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MyApp), findsOneWidget);

    // Game() startet einen dauerhaft laufenden Ticker; Flutter prüft direkt
    // am Ende des Testkörpers, ob noch Animationen laufen.
    Game.mInstance?.dispose();
    Game.mInstance = null;
  });
}
