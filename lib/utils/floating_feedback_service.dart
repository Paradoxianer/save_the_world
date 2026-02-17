import 'package:flutter/material.dart';

class FloatingFeedbackService {
  static final FloatingFeedbackService _instance = FloatingFeedbackService._internal();
  factory FloatingFeedbackService() => _instance;
  FloatingFeedbackService._internal();

  // GlobalKeys to track resource positions in the AppBar
  final Map<String, GlobalKey> resourceKeys = {};

  void registerResourceKey(String name, GlobalKey key) {
    resourceKeys[name] = key;
  }

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

  /// Helper to trigger feedback specifically for a resource in the AppBar
  void showAtResource(BuildContext context, String resourceName, String value, bool isPositive) {
    final key = resourceKeys[resourceName];
    if (key == null || key.currentContext == null) return;

    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    
    // Adjust position to center of the icon
    final centerPosition = Offset(
      position.dx + renderBox.size.width / 2,
      position.dy + renderBox.size.height / 2,
    );

    show(
      context,
      position: centerPosition,
      text: "${isPositive ? '+' : ''}$value",
      color: isPositive ? Colors.green : Colors.red,
    );
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
  late Animation<Offset> _moveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_controller);

    _moveAnimation = Tween<Offset>(
      begin: widget.position,
      end: widget.position + const Offset(0, -60), // Fly upwards
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

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
          left: _moveAnimation.value.dx - 50, // Center roughly
          top: _moveAnimation.value.dy,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null)
                    Icon(widget.icon, color: widget.color, size: 16),
                  Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      shadows: const [
                        Shadow(color: Colors.white, blurRadius: 4),
                        Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
