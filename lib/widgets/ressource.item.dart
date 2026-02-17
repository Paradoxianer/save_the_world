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
    if (_lastValue != null && newValue != _lastValue) {
      final double diff = newValue - _lastValue!;
      if (diff.abs() > 0.0001) {
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
    
    String displayValue;
    if (diff.abs() >= 1) {
      displayValue = diff.toInt().toString();
    } else if (diff.abs() >= 0.1) {
      displayValue = diff.toStringAsFixed(1);
    } else {
      displayValue = diff.toStringAsFixed(2);
    }

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
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: 3), // Cartoon border
        ),
        title: Row(
          children: [
            Icon(res.icon, size: 32, color: Colors.orange[800]),
            const SizedBox(width: 12),
            Text(res.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(res.description, style: const TextStyle(fontStyle: FontStyle.italic)),
            const Divider(height: 30, thickness: 2, color: Colors.black12),
            _detailRow("AKTUELL:", NumberFormatter.format(res.value)),
            _detailRow("MINIMUM:", NumberFormatter.format(res.min)),
            _detailRow("MAXIMUM:", NumberFormatter.format(res.max)),
            const SizedBox(height: 20),
            // Capacity Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (res.value - res.min) / (res.max - res.min).clamp(0.001, double.infinity),
                minHeight: 12,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[700]!),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("VERSTANDEN", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
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
        fontWeight: isNegative ? FontWeight.bold : FontWeight.normal,
      );
      iconColor = isNegative ? Colors.red : Colors.black87;
    }

    return GestureDetector(
      onTap: _showResourceDetails,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              res.icon, 
              size: widget.size,
              color: iconColor,
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
