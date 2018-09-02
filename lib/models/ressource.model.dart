import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class Ressource extends GameElement {
  double min = 0.0;
  double value;
  double max = 100.0;
  Ressource ({String name,String description, IconData icon,this.value,List<Modifier> modifier}) :
    super(name: name,description : description, icon : icon);
}