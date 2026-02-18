import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/widgets/comic_panel_dialog.dart';

class CelebrationDialog extends StatefulWidget {
  final int stage;
  final Duration? duration; 
  final int? clicks;
  final int? score;

  const CelebrationDialog({
    super.key, 
    required this.stage,
    this.duration,
    this.clicks,
    this.score,
  });

  @override
  State<CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<CelebrationDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    // Start explosion after a tiny delay for better visual impact
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes > 0) {
      return "${duration.inMinutes}m ${duration.inSeconds % 60}s";
    }
    return "${duration.inSeconds}s";
  }

  @override
  Widget build(BuildContext context) {
    List<int> stageList = levels.keys.toList();
    final stageTitle = levels[stageList[widget.stage]] ?? "Unbekannt";
    final maxMembers = stageList[widget.stage].toString();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ComicPanelDialog(
          title: 'GRATULATION!',
          icon: Icons.emoji_events,
          headerColor: Colors.amber[700]!,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "DU HAST EINE NEUE STUFE ERREICHT!",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              const SizedBox(height: 20),
              
              // TROPHY AREA
              SizedBox(
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/award.png',
                      height: 130,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      top: 40,
                      child: Text(
                        widget.stage.toString(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              
              Text(
                stageTitle.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w900, 
                  fontSize: 22,
                  color: Colors.orange,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                "Dein Limit: $maxMembers Mitglieder",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600], 
                  fontSize: 14, 
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
                ),
              ),
              
              const Divider(height: 32, thickness: 2),
              
              // STATS
              _buildStatsArea(),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.black, width: 2.5),
                ),
              ),
              child: const Text('WEITER DIENEN', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
        
        // CONFETTI OVERLAY
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
              Colors.amber
            ],
            gravity: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsArea() {
    return Column(
      children: [
        const Text(
          "DEINE PERFORMANCE", 
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.grey, letterSpacing: 1)
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (widget.duration != null)
              _statItem(Icons.timer, _formatDuration(widget.duration!)),
            if (widget.clicks != null)
              _statItem(Icons.touch_app, "${widget.clicks}"),
            if (widget.score != null)
              _statItem(Icons.stars, "${widget.score}", isScore: true),
          ],
        ),
      ],
    );
  }

  Widget _statItem(IconData icon, String text, {bool isScore = false}) {
    return Column(
      children: [
        Icon(icon, size: isScore ? 28 : 22, color: isScore ? Colors.amber[800] : Colors.grey[700]),
        const SizedBox(height: 4),
        Text(
          text, 
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            fontSize: isScore ? 18 : 14,
            color: isScore ? Colors.amber[900] : Colors.black87
          )
        ),
      ],
    );
  }
}

void showCelebration(BuildContext context, int stage, {Duration? duration, int? clicks, int? score}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, anim1, anim2) => Container(),
    barrierDismissible: false,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.elasticOut),
          child: CelebrationDialog(
            stage: stage,
            duration: duration,
            clicks: clicks,
            score: score,
          ),
        ),
      );
    },
  );
}
