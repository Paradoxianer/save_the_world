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
  final GlobalKey _iconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.ressource.addListener(_handleUpdate);
    
    // Register the key for floating feedback (only if it's a global resource)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FloatingFeedbackService().registerResourceKey(widget.ressource.name, _iconKey);
      }
    });
  }

  @override
  void didUpdateWidget(RessourceItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ressource != widget.ressource) {
      oldWidget.ressource.removeListener(_handleUpdate);
      widget.ressource.addListener(_handleUpdate);
      
      // Re-register if resource object changes
      FloatingFeedbackService().registerResourceKey(widget.ressource.name, _iconKey);
    }
  }

  @override
  void dispose() {
    widget.ressource.removeListener(_handleUpdate);
    super.dispose();
  }

  void _handleUpdate() {
    if (mounted) {
      setState(() {});
    }
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
        color: iconColor = isNegative ? Colors.red : Colors.black87,
        fontWeight: isNegative ? FontWeight.bold : FontWeight.normal,
      );
      iconColor = isNegative ? Colors.red : Colors.black87;
    }

    return Padding(
      key: _iconKey, // ATTACH THE KEY HERE
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
