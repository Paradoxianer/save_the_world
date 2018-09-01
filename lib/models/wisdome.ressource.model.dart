import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Wisdome extends Ressource {
  const Wisdome({double value}):
        super(
          name:"Weisheit",
          description:"wieviel Weisheit du hast",
          icon : Icons.school,
          value: value,
          modifier: null
      );
}
