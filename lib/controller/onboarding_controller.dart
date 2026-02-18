import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/about.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/comic_panel_dialog.dart';

class OnboardingController {
  /// Startet die Onboarding-Sequenz (DSGVO -> Story Intro)
  /// [force] erzwingt das Anzeigen der Dialoge, auch wenn sie bereits gesehen wurden.
  static Future<void> startSequence(BuildContext context, {bool force = false, Function(bool)? onDsgvoUpdated}) async {
    final dataManager = Game.getInstance().dataManager;
    
    // 1. DSGVO CHECK
    final dsgvoStatus = await dataManager.readData("dsgvo_accepted");
    if (dsgvoStatus != "true" || force) {
      final result = await showDSGVODialog(context);
      if (result == ConfirmAGB.ACCEPT) {
        await dataManager.writeJson("dsgvo_accepted", "true");
        if (onDsgvoUpdated != null) onDsgvoUpdated(true);
      } else {
        if (onDsgvoUpdated != null) onDsgvoUpdated(false);
        if (!force) return; // Abbrechen nur beim automatischen Start relevant
      }
    } else {
      if (onDsgvoUpdated != null) onDsgvoUpdated(true);
    }

    // 2. STORY INTRO CHECK
    final introSeen = await dataManager.readData("intro_seen");
    if (introSeen != "true" || force) {
      await showStoryIntro(context);
      await dataManager.writeJson("intro_seen", "true");
    }
  }

  /// Zeigt den Story-Intro Dialog im Comic-Stil (Heilsarmee-Kontext)
  static Future<void> showStoryIntro(BuildContext context) async {
    return context.showComicDialog(
      title: "DEIN RUF",
      icon: Icons.church,
      headerColor: Colors.amber[700]!,
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "WILLKOMMEN, OFFIZIER!",
              style: TextStyle(
                fontWeight: FontWeight.w900, 
                fontSize: 18, 
                color: Colors.orange,
                letterSpacing: 1.2
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Als Offizier der Heilsarmee ist es deine Mission, die Botschaft der Hoffnung zu verbreiten und Seelen zu retten.\n\n"
              "DEIN ZIEL: Vergrößere deine Gemeinde! Je mehr Mitglieder du hast, desto mehr kannst du in der Welt bewirken.\n\n"
              "WICHTIG: Achte auf 'GOLDENE AUFGABEN' (Meilensteine). Nur wenn du diese erledigst, kannst du dein Mitglieder-Limit erhöhen und in die nächste Stufe aufsteigen.\n\n"
              "Nutze deine Ressourcen Gebet, Glauben und Zeit weise. Die Welt wartet auf deinen Dienst!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 14, 
                height: 1.5,
                color: Colors.black87
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.black, width: 2.5),
            ),
          ),
          child: const Text(
            "BEREIT ZUM DIENST!",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)
          ),
        ),
      ],
    );
  }
}
