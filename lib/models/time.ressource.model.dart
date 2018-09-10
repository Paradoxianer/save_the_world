import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Time extends Ressource {
  Time({double value}):
        super(
          name:"Zeit",
          description:"wieviel Zeit du hast",
          icon : Icons.access_time,
          value: value,
          modifier: null
      )
  {
    this.min = 0.0;
    this.max = 24.0;
  }
}
