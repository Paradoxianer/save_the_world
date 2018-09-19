import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Member extends Ressource {
   Member({double value}):
        super(
           name: "Member",
          description:"wieviele Mitglieder hast du",
          icon : Icons.group,
          value: value,
          modifier: null
   ){
     this.min = 1.0;
     this.max = double.maxFinite;
   }

   factory Member.fromJson(Map<String, dynamic> json){
     return Member(value: json['value']);
   }

   Map<String, dynamic> toJson() {
     return <String, dynamic>{
       'name': name,
       'value': value
     };
   }
}
