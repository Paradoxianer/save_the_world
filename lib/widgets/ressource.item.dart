import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/utils/number_formatter.dart';
import 'package:save_the_world_flutter_app/utils/floating_feedback_service.dart';

class RessourceItem extends StatefulWidget {
  final Ressource ressource;
  final double size;
  final bool isGlobal; 

  const RessourceItem(this.ressource, {super.key, this.size = 30.0, this.isGlobal = false});

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
    
    // Only trigger feedback if this is a global display (AppBar)
    // and the value has actually changed.
    if (widget.isGlobal && _lastValue != null && newValue != _lastValue) {
      final double diff = newValue - _lastValue!;
      
      // We only show feedback for significant enough changes 
      // (or all changes if you prefer)
      if (diff.abs() > 0.001) {
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
    
    // Format the number nicely
    String displayValue;
    if (diff.abs() >= 1) {
      displayValue = diff.toInt().toString();
    } else {
      displayValue = diff.toStringAsFixed(1);
    }

    FloatingFeedbackService().show(
      context,
      position: centerPosition,
      text: "$sign$displayValue",
      color: isPositive ? Colors.green : Colors.red,
      icon: widget.ressource.icon,
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

    return Padding(
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
    );
  }
}
