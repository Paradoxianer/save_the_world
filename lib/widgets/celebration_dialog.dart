import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/globals.dart';

class CelebrationDialog extends StatefulWidget {
  final int stage;
  final Duration? duration; 
  final int? clicks;       

  const CelebrationDialog({
    super.key, 
    required this.stage,
    this.duration,
    this.clicks,
  });

  @override
  State<CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<CelebrationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'GRATULATION!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("Du hast eine neue Stufe erreicht:"),
                  const SizedBox(height: 20),
                  
                  SizedBox(
                    height: 180,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Image.asset(
                          'assets/icons/award.png',
                          height: 170,
                          fit: BoxFit.contain,
                        ),
                        Positioned(
                          top: 22,
                          child: Text(
                            widget.stage.toString(),
                            style: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  Text(
                    stageTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 22,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      "Die Gemeinde wächst! Dein Limit liegt nun bei $maxMembers Mitgliedern.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  
                  if (widget.duration != null || widget.clicks != null)
                    _buildStatsArea(),

                  const SizedBox(height: 30),
                  
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('WEITER DIENEN'),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsArea() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text("DEINE STATISTIK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (widget.duration != null)
                _statItem(Icons.timer, _formatDuration(widget.duration!)),
              if (widget.clicks != null)
                _statItem(Icons.touch_app, "${widget.clicks}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.orange),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

void showCelebration(BuildContext context, int stage, {Duration? duration, int? clicks}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, anim1, anim2) => Container(),
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (context, anim1, anim2, child) {
      return CelebrationDialog(
        stage: stage,
        duration: duration,
        clicks: clicks,
      );
    },
  );
}
