import 'package:flutter/material.dart';

class ComicSnackBar {
  static void show(BuildContext context, String message) {
    // Bestimme Icon und Farbe basierend auf Inhalt (Heuristik)
    String icon = "📢";
    Color bgColor = Colors.blueAccent;
    
    final lowerMsg = message.toLowerCase();
    if (lowerMsg.contains("achtung") || lowerMsg.contains("warnung") || lowerMsg.contains("gefahr")) {
      icon = "⚠️";
      bgColor = const Color(0xFFE53935); // RedAccent-ish
    } else if (lowerMsg.contains("erfolg") || lowerMsg.contains("geschafft") || lowerMsg.contains("neue stufe")) {
      icon = "🏆";
      bgColor = const Color(0xFF43A047); // Green
    } else if (lowerMsg.contains("aufgabe")) {
      icon = "📝";
      bgColor = Colors.orange;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 12),
        // Margin angepasst, um direkt über der Bottom Bar zu schweben (ca. 12px Abstand)
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12), 
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: 2.5),
        ),
        action: SnackBarAction(
          label: '✕',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
