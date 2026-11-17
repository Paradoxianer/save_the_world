import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Leitet path_provider auf ein frisches temporäres Verzeichnis um und
/// räumt es nach der Testdatei wieder ab.
///
/// Vorher lieferten die Tests "." als Dokumentenordner: Game.saveState()
/// schrieb die Spielstände ins Repo-Wurzelverzeichnis (Game.json,
/// gameRes.json, activeTasks.json, allTasks.json), und Game.loadState() im
/// nächsten Test las sie wieder ein - Ergebnisse hingen von der
/// Ausführungsreihenfolge ab, und jeder Testlauf hinterließ geänderte Dateien
/// im Arbeitsverzeichnis.
Directory useTempDocumentsDirectory() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final dir = Directory.systemTemp.createTempSync('save_the_world_test_');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (MethodCall call) async => dir.path,
  );
  tearDownAll(() {
    try {
      dir.deleteSync(recursive: true);
    } on FileSystemException {
      // Ein noch laufender asynchroner saveState() kann gerade schreiben -
      // das Temp-Verzeichnis räumt dann das Betriebssystem auf.
    }
  });
  return dir;
}
