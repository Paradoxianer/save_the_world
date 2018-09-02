import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Publicity extends Ressource {
  Publicity({double value}):
        super(
          name:"Bekanntheit",
          description:"wie bekannt du bist",
          icon : Icons.live_tv,
          value: value,
          modifier: null
  );
}
