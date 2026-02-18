import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Wisdom extends Ressource {
  Wisdom({
    double? value,
    super.multiplierResourceName,
    super.multiplierValue,
  }) : super(
          name: "Wisdom",
          description: "wieviel Weisheit du hast",
          icon: Icons.school,
          value: value,
          min: double.negativeInfinity,
          max: double.maxFinite,
        );

  factory Wisdom.fromJson(Map<String, dynamic> json) {
    return Wisdom(
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
