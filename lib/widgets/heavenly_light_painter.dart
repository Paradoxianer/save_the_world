import 'dart:math';
import 'package:flutter/material.dart';

/// Malt einen ruhigen, animierten Himmel mit Lichtstrahlen, weichen Wolken
/// und aufsteigenden Lichtpartikeln - bewusst ohne eine Figur, die Jesus
/// darstellen soll. Herrlichkeit als Licht statt als Abbild.
class HeavenlyLightPainter extends CustomPainter {
  /// Läuft von 0.0 bis 1.0 in einer Endlosschleife.
  final double t;

  HeavenlyLightPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = Offset(size.width / 2, size.height * 0.28);

    // Himmel-Verlauf: dunkles Blau oben, helles Gold-Weiß am Lichtpunkt.
    final sky = Paint()
      ..shader = RadialGradient(
        center: Alignment(0, -0.4),
        radius: 1.3,
        colors: const [
          Color(0xFFFFF8E1),
          Color(0xFFBEE3F8),
          Color(0xFF4A7BAE),
          Color(0xFF0E2A4A),
          Color(0xFF091A30),
        ],
        stops: const [0.0, 0.25, 0.55, 0.85, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, sky);

    _paintRays(canvas, center, size);
    _paintClouds(canvas, size);
    _paintParticles(canvas, size);
  }

  void _paintRays(Canvas canvas, Offset center, Size size) {
    final rayCount = 10;
    final maxLen = size.longestSide;
    for (int i = 0; i < rayCount; i++) {
      final baseAngle = (2 * pi / rayCount) * i;
      final wobble = sin(t * 2 * pi + i) * 0.05;
      final angle = baseAngle + wobble;
      final pulse = 0.18 + 0.10 * (0.5 + 0.5 * sin(t * 2 * pi + i * 0.7));

      final path = Path();
      final spread = 0.10;
      final p1 = center;
      final p2 = center + Offset(cos(angle - spread) * maxLen, sin(angle - spread) * maxLen);
      final p3 = center + Offset(cos(angle + spread) * maxLen, sin(angle + spread) * maxLen);
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(p3.dx, p3.dy);
      path.close();

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: pulse),
            Colors.white.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: maxLen));
      canvas.drawPath(path, paint);
    }
  }

  void _paintClouds(Canvas canvas, Size size) {
    final cloudSeeds = [
      Offset(0.15, 0.55),
      Offset(0.82, 0.62),
      Offset(0.35, 0.78),
      Offset(0.65, 0.40),
      Offset(0.10, 0.85),
      Offset(0.90, 0.30),
    ];
    for (int i = 0; i < cloudSeeds.length; i++) {
      final seed = cloudSeeds[i];
      final drift = sin(t * 2 * pi + i * 1.3) * 0.02;
      final dx = (seed.dx + drift) * size.width;
      final dy = seed.dy * size.height;
      final radius = size.width * (0.16 + 0.03 * (i.isEven ? 1 : -1));

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.10 + 0.03 * sin(t * 2 * pi + i))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.6);
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  void _paintParticles(Canvas canvas, Size size) {
    final rnd = Random(7);
    const particleCount = 26;
    for (int i = 0; i < particleCount; i++) {
      final phase = (t + i / particleCount) % 1.0;
      final baseX = rnd.nextDouble();
      final wobbleX = sin(phase * 2 * pi + i) * 0.02;
      final dx = (baseX + wobbleX) * size.width;
      final dy = size.height * (1.0 - phase);
      final opacity = sin(phase * pi); // fährt sanft hoch und wieder runter
      final radius = 1.5 + rnd.nextDouble() * 2.0;

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.55 * opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant HeavenlyLightPainter oldDelegate) => oldDelegate.t != t;
}
