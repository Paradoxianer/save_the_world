import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Time extends Ressource {
  Time({
    double? value,
    super.multiplierResourceName,
    super.multiplierValue,
  }) : super(
          name: "Time",
          description: "wieviel Zeit du hast",
          icon: Icons.access_time,
          value: value,
          min: 0.0,
          max: 24.0,
        );

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      value: (json['value'] as num?)?.toDouble(),
      multiplierResourceName: json['multiplierResourceName'] as String?,
      multiplierValue: (json['multiplierValue'] as num?)?.toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}
