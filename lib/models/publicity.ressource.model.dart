import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Publicity extends Ressource {
  Publicity({double value}) :
        super(
          name: "Publicity",
          description: "wie bekannt du bist",
          icon: Icons.live_tv,
          value: value,
          modifier: null
      ) {
    this.min = 0.0;
    this.max = double.maxFinite;
  }

  factory Publicity.fromJson(Map<String, dynamic> json){
    return Publicity(value: json['value']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'value': value
    };
  }
}
