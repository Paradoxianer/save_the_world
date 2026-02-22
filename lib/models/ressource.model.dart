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

  double get value {
    double base = _value;
    if (multiplierResourceName != null && multiplierValue != null) {
      final factorRes = Game.ressources[multiplierResourceName!];
      if (factorRes != null) {
        base = _value * factorRes.value * multiplierValue!;
      }
    }
    return base;
  }

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

  /// Hilfsmethode, um JSON-Werte (Zahl oder String) sicher in double umzuwandeln.
  /// Jetzt korrekt als static deklariert.
  static double parseJsonDouble(dynamic val, double defaultValue) {
    if (val == null) return defaultValue;
    if (val is num) return val.toDouble();
    if (val is String) {
      if (val.contains("Infinity")) return val.startsWith("-") ? -1e15 : 1e15;
      if (val == "NaN") return defaultValue;
      return double.tryParse(val) ?? defaultValue;
    }
    return defaultValue;
  }

  /// Hilfsmethode, um double sicher für JSON vorzubereiten.
  /// Jetzt korrekt als static deklariert.
  static dynamic encodeJsonDouble(double val) {
    if (val.isInfinite) return val.isNegative ? "-Infinity" : "Infinity";
    if (val.isNaN) return "NaN";
    return val;
  }

  factory Ressource.fromJson(Map<String, dynamic> json) {
    String name = json['name'] ?? "Unknown";
    double val = parseJsonDouble(json['value'], 0.0);
    
    Ressource res;
    switch (name) {
      case "Faith": res = Faith(value: val); break;
      case "Member": res = Member(value: val); break;
      case "Money": res = Money(value: val); break;
      case "Publicity": res = Publicity(value: val); break;
      case "Time": res = Time(value: val); break;
      case "Wisdom": res = Wisdom(value: val); break;
      default: res = Ressource(name: name, value: val);
    }
    
    res.min = parseJsonDouble(json['min'], res.min);
    res.max = parseJsonDouble(json['max'], res.max);
    res.multiplierResourceName = json['multiplierResourceName'] as String?;
    res.multiplierValue = (json['multiplierValue'] as num?)?.toDouble();
    return res;
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'min': encodeJsonDouble(_min),
      'value': encodeJsonDouble(_value), 
      'max': encodeJsonDouble(_max),
      'multiplierResourceName': multiplierResourceName,
      'multiplierValue': multiplierValue,
    };
  }

  void subtract(Ressource other) {
    _value -= other.value;
    if (_value < _min) _value = _min;
    notifier.notifyListeners();
  }

  void add(Ressource other) {
    _value += other.value;
    if (_value > _max) _value = _max;
    notifier.notifyListeners();
  }

  void setValue(double newVal) {
    _value = newVal;
    notifier.notifyListeners();
  }

  bool canAdd(Ressource other) {
    if (name == other.name) return (this.value + other.value) <= _max;
    return false;
  }

  bool canSubtract(Ressource other) {
    if (name == other.name) return (this.value - other.value) >= _min;
    return false;
  }
}
