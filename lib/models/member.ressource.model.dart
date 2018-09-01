import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Member extends Ressource {
  const Member({double value}):
        super(
          name:"Mitglieder",
          description:"wieviele Mitglieder hast du",
          icon : Icons.group,
          value: value,
          modifier: null
      );
}
