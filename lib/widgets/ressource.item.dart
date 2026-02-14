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
  @override
  void initState() {
    super.initState();
    widget.ressource.addListener(valueChanged);
  }

  @override
  void dispose() {
    widget.ressource.removeListener(valueChanged);
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
    TextStyle stl;

    if (gameRes != null && (gameRes != widget.ressource) && (!widget.ressource.willAdd)) {
      if (gameRes.canSubtract(widget.ressource)) {
        stl = const TextStyle(color: Colors.green);
      } else {
        stl = const TextStyle(color: Colors.red);
      }
    } else {
      stl = const TextStyle(color: Colors.black);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(widget.ressource.icon, size: widget.size),
        Text(
          widget.ressource.value.toStringAsFixed(1),
          textScaler: TextScaler.linear(widget.size / 30.0),
          style: stl,
        ),
      ],
    );
  }
}
