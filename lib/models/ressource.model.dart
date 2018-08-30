import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class Ressource extends GameElement {
  final double min = 0.0;
  final double value;
  final double max = 100.0;
  const Ressource ({String name,String description, IconData icon,this.value,List<Modifier> modifer}) :
    super(name: name,description : description, icon : icon);
}