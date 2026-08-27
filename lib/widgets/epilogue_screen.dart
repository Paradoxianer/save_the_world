import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/heavenly_light_painter.dart';

/// Wird ab dem zweiten App-Start nach dem Sieg statt des normalen Spiels
/// gezeigt - ruhig und statisch, im Gegensatz zum einmaligen WinScreen-
/// Lauftext. "Von vorn beginnen" steht bewusst klein und zurückhaltend da,
/// nicht als Hauptaktion: man rettet nicht zweimal dieselbe Welt.
class EpilogueScreen extends StatefulWidget {
  const EpilogueScreen({super.key});

  @override
  State<EpilogueScreen> createState() => _EpilogueScreenState();
}

class _EpilogueScreenState extends State<EpilogueScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _skyController;

  @override
  void initState() {
    super.initState();
    _skyController = AnimationController(vsync: this, duration: const Duration(seconds: 50))..repeat();
  }

  @override
  void dispose() {
    _skyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalScore = Game.getInstance().stageHighscores.values.fold<int>(0, (a, b) => a + b);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _skyController,
            builder: (context, _) => CustomPaint(
              painter: HeavenlyLightPainter(_skyController.value),
              size: Size.infinite,
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "DEINE REISE IST VOLLENDET",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "Jesus ist wiedergekommen.\nDer Auftrag ist vollbracht.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                    ),
                    if (totalScore > 0) ...[
                      const SizedBox(height: 24),
                      Text(
                        "Gesamtpunktzahl: $totalScore",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                    const SizedBox(height: 48),
                    TextButton(
                      onPressed: () => Game.getInstance().resetGame(),
                      child: const Text(
                        "Von vorn beginnen",
                        style: TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
