import 'package:flutter/material.dart';

class FloatingFeedbackService {
  static final FloatingFeedbackService _instance = FloatingFeedbackService._internal();
  factory FloatingFeedbackService() => _instance;
  FloatingFeedbackService._internal();

  void show(BuildContext context, {
    required Offset position,
    required String text,
    required Color color,
    IconData? icon,
  }) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _FloatingLabel(
        position: position,
        text: text,
        color: color,
        icon: icon,
        onComplete: () {
          overlayEntry.remove();
        },
      ),
    );

    overlayState.insert(overlayEntry);
  }
}

class _FloatingLabel extends StatefulWidget {
  final Offset position;
  final String text;
  final Color color;
  final IconData? icon;
  final VoidCallback onComplete;

  const _FloatingLabel({
    required this.position,
    required this.text,
    required this.color,
    this.icon,
    required this.onComplete,
  });

  @override
  State<_FloatingLabel> createState() => _FloatingLabelState();
}

class _FloatingLabelState extends State<_FloatingLabel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _yAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 25),
    ]).animate(_controller);

    _yAnimation = Tween<double>(
      begin: widget.position.dy,
      end: widget.position.dy - 80, 
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: widget.position.dx - 40,
          top: _yAnimation.value,
          child: IgnorePointer(
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null)
                      Icon(widget.icon, color: widget.color, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      widget.text,
                      style: TextStyle(
                        color: widget.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        shadows: const [
                          Shadow(color: Colors.white, blurRadius: 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
