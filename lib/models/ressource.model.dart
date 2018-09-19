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
  double value;
  double max = 100.0;

  Ressource({String name, String description, IconData icon, this.value, List<
      Modifier> modifier, this.min, this.max}) :
    super(name: name,description : description, icon : icon){
    notifier=new ChangeNotifier();
  }

  factory Ressource.fromJson(Map<String, dynamic> json){
    String whatModifier = json['name'];
    switch (whatModifier) {
      case "Faith":
        return Faith(value: json['value']);
        break;
      case "Member":
        return Member
          (value: json['value']);
        break;
      case "Money":
        return Money(value: json['value']);
        break;
      case "Publicity":
        return Publicity(value: json['value']);
        break;
      case "Time":
        return Time(value: json['value']);
        break;
      case "Weisheit":
        return Wisdom(value: json['value']);
        break;
    }
  }


  Map<String, dynamic> toJson() {
    //ToDo: implement json of the modifier list.
    return <String, dynamic>{
      'name': name,
      'icon': icon,
      'min': min,
      'value': value,
      'max': max,
    };
  }


  subtract(Ressource other){
    this.value-=other.value;
    if (this.value<min){
      this.value=min;
    }
    notifier.notifyListeners();
  }

  add(Ressource other){
    this.value+=other.value;
    if (this.value>max){
      this.value=max;
    }
    notifier.notifyListeners();
  }

  bool canAdd(Ressource other){
    if (this.name == other.name){
      if ((this.value+other.value)<=max)
        return true;
      else
        return false;
    }
    else
      return false;
  }

  bool canSubtract(Ressource other){
    if (this.name == other.name){
      if ((this.value-other.value)>=min)
        return true;
      else
        return false;
    }
    else
      return false;
  }
}