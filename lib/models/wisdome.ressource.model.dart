import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Wisdom extends Ressource {
  Wisdom({double value}) :
        super(
          name: "Weisheit",
          description: "wieviel Weisheit du hast",
          icon: Icons.school,
          value: value,
          modifier: null
      ) {
    this.min = double.negativeInfinity;
    this.max = double.maxFinite;
  }

  factory Wisdom.fromJson(Map<String, dynamic> json){
    return Wisdom(value: json['value']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'value': value
    };
  }
}
