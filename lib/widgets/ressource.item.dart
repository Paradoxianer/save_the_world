import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class RessourceItem extends StatelessWidget {
  final Ressource ressource;

  RessourceItem(this.ressource);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(ressource.icon),
        Text(ressource.value.toString()),
      ],
    );
  }
}