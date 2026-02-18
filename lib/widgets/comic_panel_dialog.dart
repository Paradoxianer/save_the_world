import 'package:flutter/material.dart';

class ComicPanelDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;
  final Color headerColor;
  final IconData? icon;
  final double? maxWidth;

  const ComicPanelDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.headerColor = Colors.blueAccent,
    this.icon,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 400),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // THE SHADOW LAYER (Offset 6, 6)
            Positioned(
              top: 6,
              left: 6,
              right: -6,
              bottom: -6,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            
            // THE MAIN PANEL
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.black, width: 3.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // HEADER PANEL
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: headerColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      border: const Border(
                        bottom: BorderSide(color: Colors.black, width: 3.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Text(
                            title.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // CONTENT AREA
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: content,
                    ),
                  ),
                  
                  // ACTIONS (Buttons)
                  if (actions != null && actions!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: actions!,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper extension to easily show the comic dialog
extension ComicDialogExtension on BuildContext {
  Future<T?> showComicDialog<T>({
    required String title,
    required Widget content,
    List<Widget>? actions,
    Color headerColor = Colors.blueAccent,
    IconData? icon,
  }) {
    return showDialog<T>(
      context: this,
      builder: (context) => ComicPanelDialog(
        title: title,
        content: content,
        actions: actions,
        headerColor: headerColor,
        icon: icon,
      ),
    );
  }
}
