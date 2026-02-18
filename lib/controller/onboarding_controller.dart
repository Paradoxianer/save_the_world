import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/about.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/comic_panel_dialog.dart';

class OnboardingController {
  /// Startet die Onboarding-Sequenz (DSGVO -> Story Intro)
  static Future<void> startSequence(BuildContext context, {Function(bool)? onDsgvoUpdated}) async {
    final dataManager = Game.getInstance().dataManager;
    
    // 1. DSGVO CHECK
    final dsgvoStatus = await dataManager.readData("dsgvo_accepted");
    if (dsgvoStatus != "true") {
      final result = await showDSGVODialog(context);
      if (result == ConfirmAGB.ACCEPT) {
        await dataManager.writeJson("dsgvo_accepted", "true");
        if (onDsgvoUpdated != null) onDsgvoUpdated(true);
      } else {
        // Nutzer hat abgebrochen -> Onboarding stoppen
        if (onDsgvoUpdated != null) onDsgvoUpdated(false);
        return; 
      }
    } else {
      if (onDsgvoUpdated != null) onDsgvoUpdated(true);
    }

    // 2. STORY INTRO CHECK
    final introSeen = await dataManager.readData("intro_seen");
    if (introSeen != "true") {
      await showStoryIntro(context);
      await dataManager.writeJson("intro_seen", "true");
    }
  }

  /// Zeigt den Story-Intro Dialog im Comic-Stil
  static Future<void> showStoryIntro(BuildContext context) async {
    return context.showComicDialog(
      title: "DEINE MISSION",
      icon: Icons.auto_awesome,
      headerColor: Colors.amber[700]!,
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "WILLKOMMEN, RETTER!",
            style: TextStyle(
              fontWeight: FontWeight.w900, 
              fontSize: 18, 
              color: Colors.orange,
              letterSpacing: 1.2
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Die Welt versinkt im Chaos. Überall brennt es, und die Hoffnung schwindet.\n\n"
            "Deine Aufgabe ist es, eine Gemeinschaft aufzubauen, Menschen zu inspirieren und Ressourcen klug zu verwalten.\n\n"
            "Wachse über dich hinaus, um die Welt Stufe für Stufe zu retten. Bist du bereit?",
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
            "ICH BIN BEREIT!", 
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)
          ),
        ),
      ],
    );
  }
}
