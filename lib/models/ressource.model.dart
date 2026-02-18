import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

class Ressource extends GameElement {
  double _min = 0.0;
  double _value = 0.0;
  double _max = 100.0;
  bool willAdd = true;

  // NEW: Fields for dynamic calculation (#55)
  String? multiplierResourceName;
  double? multiplierValue;

  Ressource({
    super.name,
    super.description,
    super.icon,
    double? value,
    this.multiplierResourceName,
    this.multiplierValue,
    List<Modifier>? modifier,
    double min = 0.0,
    double max = 100.0,
  }) : super(myModifier: modifier) {
    _min = min;
    _max = max;
    if (value != null) _value = value;
  }

  // DYNAMIC GETTER: Calculates value on the fly if multiplier is set
  double get value {
    if (multiplierResourceName != null && multiplierValue != null) {
      final factorRes = Game.ressources[multiplierResourceName!];
      if (factorRes != null) {
        return _value * factorRes.value * multiplierValue!;
      }
    }
    return _value;
  }

  // Setter now only sets the base value
  set value(double val) {
    _value = val;
    notifier.notifyListeners();
  }

  double get min => _min;
  double get max => _max;

  set min(double val) {
    _min = val;
    notifier.notifyListeners();
  }

  set max(double val) {
    _max = val;
    notifier.notifyListeners();
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
    res.multiplierResourceName = json['multiplierResourceName'] as String?;
    res.multiplierValue = (json['multiplierValue'] as num?)?.toDouble();
    return res;
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'min': min,
      'value': _value, // Store the base value, not the calculated one
      'max': max,
      'multiplierResourceName': multiplierResourceName,
      'multiplierValue': multiplierValue,
    };
  }

  void subtract(Ressource other) {
    _value -= other.value; // Uses the getter, so dynamic values work here too
    if (_value < _min) {
      _value = _min;
    }
    notifier.notifyListeners();
  }

  void add(Ressource other) {
    _value += other.value; // Uses the getter, so dynamic values work here too
    if (_value > _max) {
      _value = _max;
    }
    notifier.notifyListeners();
  }

  void setValue(double newVal) {
    _value = newVal;
    notifier.notifyListeners();
  }

  bool canAdd(Ressource other) {
    if (name == other.name) {
      return (this.value + other.value) <= _max;
    }
    return false;
  }

  bool canSubtract(Ressource other) {
    if (name == other.name) {
      return (this.value - other.value) >= _min;
    }
    return false;
  }

  @override
  String toString() {
    return 'Ressource{name: $name, min: $min, value: $value, max: $max}';
  }
}
