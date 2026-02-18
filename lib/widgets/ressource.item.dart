import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/utils/number_formatter.dart';
import 'package:save_the_world_flutter_app/utils/floating_feedback_service.dart';

class RessourceItem extends StatefulWidget {
  final Ressource ressource;
  final double size;

  const RessourceItem(this.ressource, {super.key, this.size = 30.0});

  @override
  RessourceItemState createState() => RessourceItemState();
}

class RessourceItemState extends State<RessourceItem> {
  double? _lastValue;

  @override
  void initState() {
    super.initState();
    _lastValue = widget.ressource.value;
    widget.ressource.addListener(_handleUpdate);
  }

  @override
  void didUpdateWidget(RessourceItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ressource != widget.ressource) {
      oldWidget.ressource.removeListener(_handleUpdate);
      widget.ressource.addListener(_handleUpdate);
      _lastValue = widget.ressource.value;
    }
  }

  @override
  void dispose() {
    widget.ressource.removeListener(_handleUpdate);
    super.dispose();
  }

  void _handleUpdate() {
    if (!mounted) return;

    final double newValue = widget.ressource.value;
    
    // Safety check for feedback trigger
    if (_lastValue != null && newValue != _lastValue) {
      final double diff = newValue - _lastValue!;
      // Trigger feedback for any non-trivial and valid change
      if (!diff.isNaN && !diff.isInfinite && diff.abs() > 0.0001) {
        _triggerFeedback(diff);
      }
    }
    
    _lastValue = newValue;
    setState(() {});
  }

  void _triggerFeedback(double diff) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final centerPosition = Offset(
      position.dx + renderBox.size.width / 2,
      position.dy + renderBox.size.height / 2,
    );

    final bool isPositive = diff > 0;
    final String sign = isPositive ? "+" : "";
    
    // Format the difference robustly
    String displayValue = NumberFormatter.format(diff.abs());

    FloatingFeedbackService().show(
      context,
      position: centerPosition,
      text: "$sign$displayValue",
      color: isPositive ? Colors.green : Colors.red,
      icon: widget.ressource.icon,
    );
  }

  void _showResourceDetails() {
    final res = widget.ressource;
    
    // Safety handling for detail display
    final String valStr = NumberFormatter.format(res.value);
    final String minStr = NumberFormatter.format(res.min);
    final String maxStr = (res.max.isInfinite || res.max > 1e15) ? "∞" : NumberFormatter.format(res.max);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.black, width: 3),
        ),
        title: Row(
          children: [
            Icon(res.icon, size: 36, color: Colors.orange[800]),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                res.name.toUpperCase(), 
                style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              res.description, 
              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
            ),
            const Divider(height: 32, thickness: 2, color: Colors.black12),
            
            _detailRow("AKTUELL:", valStr),
            _detailRow("MINIMUM:", minStr),
            _detailRow("MAXIMUM:", maxStr),
            
            const SizedBox(height: 24),
            
            // Robust Capacity Bar
            if (!res.max.isInfinite && !res.max.isNaN && res.max > 0 && res.max < 1e15)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("KAPAZITÄT", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: ((res.value - res.min) / (res.max - res.min)).clamp(0.0, 1.0),
                      minHeight: 14,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[700]!),
                    ),
                  ),
                ],
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text("UNBEGRENZTE KAPAZITÄT", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.orange)),
                ),
              ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("ALLES KLAR!", style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.grey, letterSpacing: 0.5)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Ressource res = widget.ressource;
    final bool isNegative = res.value < 0;
    final Ressource? globalRes = Game.ressources[res.name];
    
    TextStyle textStyle;
    Color iconColor;

    if (globalRes != null && (res != globalRes) && (!res.willAdd)) {
      if (globalRes.canSubtract(res)) {
        textStyle = const TextStyle(color: Colors.green, fontWeight: FontWeight.bold);
        iconColor = Colors.green;
      } else {
        textStyle = const TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
        iconColor = Colors.red;
      }
    } else {
      textStyle = TextStyle(
        color: isNegative ? Colors.red : Colors.black87,
        fontWeight: isNegative ? FontWeight.bold : FontWeight.w900,
        shadows: const [Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 1)],
      );
      iconColor = isNegative ? Colors.red : Colors.black87;
    }

    return GestureDetector(
      onTap: _showResourceDetails,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
          boxShadow: const [
            BoxShadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 0, spreadRadius: 0),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 1,
                  left: 1,
                  child: Icon(res.icon, size: widget.size, color: Colors.black12),
                ),
                Icon(
                  res.icon, 
                  size: widget.size,
                  color: iconColor,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              NumberFormatter.format(res.value),
              textScaler: TextScaler.linear(widget.size / 30.0),
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
