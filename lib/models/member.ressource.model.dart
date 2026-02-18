import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Member extends Ressource {
  Member({
    double? value,
    super.multiplierResourceName,
    super.multiplierValue,
  }) : super(
          name: "Member",
          description: "wieviele Mitglieder hast du",
          icon: Icons.group,
          value: value,
          min: 1.0,
          max: double.maxFinite,
        );

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
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
