import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class RessourceItem extends StatelessWidget {
  final Ressource ressource;
  double size;

  RessourceItem(this.ressource,[this.size=30.0]);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
            ressource.icon,
          size: size
        ),
        Text(
            ressource.value.toString(),
            textScaleFactor: (size/30.0)
        ),
      ],
    );
  }
}