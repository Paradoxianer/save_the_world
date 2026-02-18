import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Money extends Ressource {
  Money({
    double? value,
    super.multiplierResourceName,
    super.multiplierValue,
  }) : super(
          name: "Money",
          description: "wieviel Geld du hast",
          icon: Icons.attach_money,
          value: value,
          min: 0.0,
          max: double.maxFinite,
        );

  factory Money.fromJson(Map<String, dynamic> json) {
    return Money(
      value: (json['value'] as num?)?.toDouble(),
      multiplierResourceName: json['multiplierResourceName'] as String?,
      multiplierValue: (json['multiplierValue'] as num?)?.toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    return data;
  }
}
