import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Faith extends Ressource {
  Faith({
    double? value,
    super.multiplierResourceName,
    super.multiplierValue,
  }) : super(
          name: "Faith",
          description: "wieviel Glauben du hast",
          icon: const IconData(59401, fontFamily: "SaveTheWorldFont"),
          value: value,
          min: double.negativeInfinity,
          max: double.maxFinite,
        );

  factory Faith.fromJson(Map<String, dynamic> json) {
    return Faith(
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
