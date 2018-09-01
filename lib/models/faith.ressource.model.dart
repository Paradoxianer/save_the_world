import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Fait extends Ressource {
  const Fait({double value}):
        super(
          name:"Glauben",
          description:"wieviel Glauben du hast",
          icon : Icons.add,
          value: value,
          modifier: null
      );
}
