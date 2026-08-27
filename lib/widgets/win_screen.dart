import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/heavenly_light_painter.dart';

/// Der einmalige Abspann, wenn "Auf die Wiederkunft warten" abgeschlossen
/// wird: ein Lauftext vor animiertem Himmel, der am Ende zu Weiß überblendet.
/// Läuft absichtlich nur ein einziges Mal - siehe Game.hasCompletedGame und
/// EpilogueScreen für alle folgenden App-Starts.
class WinScreen extends StatefulWidget {
  const WinScreen({super.key});

  @override
  State<WinScreen> createState() => _WinScreenState();
}

class _WinScreenState extends State<WinScreen> with TickerProviderStateMixin {
  late final AnimationController _skyController;
  late final AnimationController _crawlController;
  late final AnimationController _fadeController;
  bool _showRestart = false;

  static const Duration _crawlDuration = Duration(seconds: 65);
  static const Duration _fadeDuration = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _skyController = AnimationController(vsync: this, duration: const Duration(seconds: 45))..repeat();
    _crawlController = AnimationController(vsync: this, duration: _crawlDuration);
    _fadeController = AnimationController(vsync: this, duration: _fadeDuration);

    _crawlController.forward().whenCompleteOrCancel(() {
      if (!mounted) return;
      _fadeController.forward().whenCompleteOrCancel(() {
        if (!mounted) return;
        setState(() => _showRestart = true);
      });
    });
  }

  @override
  void dispose() {
    _skyController.dispose();
    _crawlController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Grobe Schätzung der Textblock-Höhe, damit der Lauftext komplett
    // von unten nach oben durchläuft, statt in der Mitte zu enden.
    const creditsHeight = 1000.0;

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
          ClipRect(
            child: AnimatedBuilder(
              animation: _crawlController,
              builder: (context, child) {
                final travel = size.height + creditsHeight;
                final dy = size.height - _crawlController.value * travel;
                return Transform.translate(offset: Offset(0, dy), child: child);
              },
              child: _Credits(width: size.width),
            ),
          ),
          AnimatedBuilder(
            animation: _fadeController,
            builder: (context, _) => IgnorePointer(
              ignoring: _fadeController.value == 0,
              child: Opacity(
                opacity: _fadeController.value,
                child: Container(color: Colors.white),
              ),
            ),
          ),
          if (_showRestart)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Game.getInstance().resetGame();
                  },
                  child: const Text(
                    "Von vorn beginnen",
                    style: TextStyle(color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Credits extends StatelessWidget {
  final double width;
  const _Credits({required this.width});

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      color: Colors.amber,
      fontSize: 32,
      fontWeight: FontWeight.w900,
      letterSpacing: 2,
    );
    const headingStyle = TextStyle(
      color: Colors.amber,
      fontSize: 15,
      fontWeight: FontWeight.w900,
      letterSpacing: 3,
    );
    const bodyStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      height: 1.6,
      fontWeight: FontWeight.w500,
    );
    const verseStyle = TextStyle(
      color: Colors.white70,
      fontSize: 15,
      fontStyle: FontStyle.italic,
      height: 1.6,
    );
    const refStyle = TextStyle(
      color: Colors.white38,
      fontSize: 13,
    );

    final game = Game.getInstance();
    final totalScore = game.stageHighscores.values.fold<int>(0, (a, b) => a + b);

    return Center(
      child: SizedBox(
        width: width > 420 ? 380 : width * 0.85,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 60),
            const Text("ES IST VOLLBRACHT", textAlign: TextAlign.center, style: titleStyle),
            const SizedBox(height: 36),
            const Text('"Siehe, ich komme bald!"', textAlign: TextAlign.center, style: verseStyle),
            const Text("(Offenbarung 22,20)", textAlign: TextAlign.center, style: refStyle),
            const SizedBox(height: 40),
            const Text(
              "Der Auftrag ist vollendet.\nJedes Knie beugt sich,\njede Zunge bekennt:\nJesus Christus ist Herr.",
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),
            const SizedBox(height: 10),
            const Text("(Philipper 2,10-11)", textAlign: TextAlign.center, style: refStyle),
            const SizedBox(height: 60),
            const Text("DEINE REISE", textAlign: TextAlign.center, style: headingStyle),
            const SizedBox(height: 20),
            const Text(
              "Von der Hausgemeinde\nbis zur Wiederkunft.",
              textAlign: TextAlign.center,
              style: bodyStyle,
            ),
            const SizedBox(height: 24),
            if (totalScore > 0)
              Text(
                "Gesamtpunktzahl: $totalScore",
                textAlign: TextAlign.center,
                style: bodyStyle.copyWith(fontSize: 15, color: Colors.white70),
              ),
            const SizedBox(height: 60),
            const Text(
              '"Wohlgetan, du guter\nund treuer Knecht!"',
              textAlign: TextAlign.center,
              style: verseStyle,
            ),
            const Text("(Matthäus 25,21)", textAlign: TextAlign.center, style: refStyle),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
