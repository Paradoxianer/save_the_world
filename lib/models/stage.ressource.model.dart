import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class StageRes extends Ressource {
  StageRes({double value = 0.0})
      : super(
          name: "Stage",
          description: "Die aktuelle Entwicklungsstufe der Gemeinde",
          icon: Icons.trending_up,
          value: value,
          min: 0.0,
          max: 100.0,
        );

  factory StageRes.fromJson(Map<String, dynamic> json) {
    return StageRes(value: (json['value'] as num?)?.toDouble() ?? 0.0);
  }
}
