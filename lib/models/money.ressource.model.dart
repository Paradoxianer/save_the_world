import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Money extends Ressource {
  Money({double value}):
        super(
          name:"Geld",
          description:"wieviel Geld du hast",
          icon : Icons.attach_money,
          value: value,
          modifier: null
  ){
    this.min = 0.0;
    this.max = double.maxFinite;
  }

  factory Money.fromJson(Map<String, dynamic> json){
    return Money(value: json['value']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'value': value
    };
  }

}
