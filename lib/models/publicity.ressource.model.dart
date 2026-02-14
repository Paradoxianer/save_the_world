import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Publicity extends Ressource {
  Publicity({double? value})
      : super(
          name: "Publicity",
          description: "wie bekannt du bist",
          icon: Icons.live_tv,
          value: value,
          min: 0.0,
          max: double.maxFinite,
        );

  factory Publicity.fromJson(Map<String, dynamic> json) {
    return Publicity(value: (json['value'] as num?)?.toDouble());
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'value': value};
  }
}
