import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

class Ressource extends GameElement {
  double min = 0.0;
  double value = 0.0;
  double max = 100.0;
  bool willAdd = true;

  Ressource({
    super.name,
    super.description,
    super.icon,
    double? value,
    List<Modifier>? modifier,
    this.min = 0.0,
    this.max = 100.0,
  }) : super(myModifier: modifier) {
    if (value != null) this.value = value;
  }

  factory Ressource.fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    double val = (json['value'] as num?)?.toDouble() ?? 0.0;
    
    Ressource res;
    switch (name) {
      case "Faith":
        res = Faith(value: val);
        break;
      case "Member":
        res = Member(value: val);
        break;
      case "Money":
        res = Money(value: val);
        break;
      case "Publicity":
        res = Publicity(value: val);
        break;
      case "Time":
        res = Time(value: val);
        break;
      case "Wisdom":
        res = Wisdom(value: val);
        break;
      default:
        res = Ressource(name: name, value: val);
    }
    
    res.min = (json['min'] as num?)?.toDouble() ?? res.min;
    res.max = (json['max'] as num?)?.toDouble() ?? res.max;
    return res;
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'min': min,
      'value': value,
      'max': max,
    };
  }

  void subtract(Ressource other) {
    value -= other.value;
    if (value < min) {
      value = min;
    }
    notifier.notifyListeners();
  }

  void add(Ressource other) {
    value += other.value;
    if (value > max) {
      value = max;
    }
    notifier.notifyListeners();
  }

  void setValue(double newVal) {
    value = newVal;
    notifier.notifyListeners();
  }

  bool canAdd(Ressource other) {
    if (name == other.name) {
      return (value + other.value) <= max;
    }
    return false;
  }

  bool canSubtract(Ressource other) {
    if (name == other.name) {
      return (value - other.value) >= min;
    }
    return false;
  }

  @override
  String toString() {
    return 'Ressource{name: $name, min: $min, value: $value, max: $max}';
  }
}
