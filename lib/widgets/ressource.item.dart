import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class RessourceItem extends StatefulWidget {
  final Ressource ressource;
  final double size;

  const RessourceItem(this.ressource, {super.key, this.size = 30.0});

  @override
  RessourceItemState createState() => RessourceItemState();
}

class RessourceItemState extends State<RessourceItem> {
  Ressource? _globalResCache;

  @override
  void initState() {
    super.initState();
    widget.ressource.addListener(valueChanged);
    
    // Sync-Fix: Listen to global resource for instant UI updates
    _globalResCache = Game.ressources[widget.ressource.name];
    _globalResCache?.addListener(valueChanged);
  }

  @override
  void dispose() {
    widget.ressource.removeListener(valueChanged);
    _globalResCache?.removeListener(valueChanged);
    super.dispose();
  }

  void valueChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Ressource? gameRes = Game.ressources[widget.ressource.name];
    final bool isNegative = (gameRes?.value ?? 0) < 0;
    
    TextStyle textStyle;
    Color iconColor;

    if (gameRes != null && (gameRes != widget.ressource) && (!widget.ressource.willAdd)) {
      if (gameRes.canSubtract(widget.ressource)) {
        textStyle = const TextStyle(color: Colors.green, fontWeight: FontWeight.bold);
        iconColor = Colors.green;
      } else {
        textStyle = const TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
        iconColor = Colors.red;
      }
    } else {
      textStyle = TextStyle(
        color: isNegative ? Colors.red : Colors.black,
        fontWeight: isNegative ? FontWeight.bold : FontWeight.normal,
      );
      iconColor = isNegative ? Colors.red : Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            widget.ressource.icon, 
            size: widget.size,
            color: iconColor,
          ),
          const SizedBox(height: 2),
          Text(
            widget.ressource.value.toStringAsFixed(1),
            textScaler: TextScaler.linear(widget.size / 30.0),
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
