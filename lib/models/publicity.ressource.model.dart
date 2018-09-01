import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Publicity extends Ressource {
  const Publicity({double value}):
        super(
          name:"Bekanntheit",
          description:"wie bekannt du bist",
          icon : Icons.accessibility,
          value: value,
          modifier: null
      );
}
