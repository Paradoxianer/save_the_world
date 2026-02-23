import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/editor/stage_editor_screen.dart';

/// Entrypoint für den Stage-Editor.
/// Starten mit: flutter run -t lib/editor_main.dart -d windows
void main() {
  runApp(const StageArchitectApp());
}

class StageArchitectApp extends StatelessWidget {
  const StageArchitectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save the World - Stage Architect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: CardThemeData( // FIX: CardThemeData statt CardTheme Widget
          color: const Color(0xFF1E1E1E),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const StageEditorScreen(),
    );
  }
}
