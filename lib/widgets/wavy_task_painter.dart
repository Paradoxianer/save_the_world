import 'dart:math';
import 'package:flutter/material.dart';

enum FillDirection { leftToRight, rightToLeft }

class WavyTaskPainter extends CustomPainter {
  final double progress;
  final Color color;
  final FillDirection direction;

  WavyTaskPainter({
    required this.progress,
    required this.color,
    this.direction = FillDirection.leftToRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()
      ..color = color.withOpacity(0.3) // Sanfter Hintergrund-Fill
      ..style = PaintingStyle.fill;

    final path = Path();
    final double width = size.width;
    final double height = size.height;
    final double fillWidth = width * progress.clamp(0.0, 1.0);

    // Wellen-Parameter (Cartoon-Style)
    const int waveCount = 2;
    final double waveHeight = height / 12; // Wie tief die Welle ist

    if (direction == FillDirection.leftToRight) {
      path.moveTo(0, 0);
      path.lineTo(fillWidth, 0);
      
      // Zeichne die vertikale Welle als Trennkante
      for (int i = 0; i <= waveCount; i++) {
        final double segmentHeight = height / waveCount;
        final double y = i * segmentHeight;
        final double nextY = (i + 1) * segmentHeight;
        
        if (i < waveCount) {
          path.quadraticBezierTo(
            fillWidth + (i % 2 == 0 ? waveHeight : -waveHeight), // Schwung nach rechts/links
            y + segmentHeight / 2,
            fillWidth,
            nextY,
          );
        }
      }
      
      path.lineTo(0, height);
      path.close();
    } else {
      // Rechts nach Links (für Krisen/Abbau)
      path.moveTo(width, 0);
      path.lineTo(width - fillWidth, 0);

      for (int i = 0; i <= waveCount; i++) {
        final double segmentHeight = height / waveCount;
        final double y = i * segmentHeight;
        final double nextY = (i + 1) * segmentHeight;

        if (i < waveCount) {
          path.quadraticBezierTo(
            (width - fillWidth) + (i % 2 == 0 ? -waveHeight : waveHeight),
            y + segmentHeight / 2,
            width - fillWidth,
            nextY,
          );
        }
      }

      path.lineTo(width, height);
      path.close();
    }

    canvas.drawPath(path, paint);
    
    // Optionale Kontur an der Wellenkante (für mehr Cartoon-Feeling)
    final borderPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
      
    // Wir extrahieren nur die Wellenkante aus dem Pfad für die Kontur
    // (In einer komplexeren Version könnte man hier einen separaten Path für die Linie nutzen)
  }

  @override
  bool shouldRepaint(WavyTaskPainter oldDelegate) {
    return oldDelegate.progress != progress || 
           oldDelegate.color != color || 
           oldDelegate.direction != direction;
  }
}
