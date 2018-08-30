import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/gameitem.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class GameElement extends GameItem {
  final List<Modifier> myModifier;
  const GameElement({String name, String description, IconData icon,this.myModifier}):super(name : name, description : description , icon : icon);
}