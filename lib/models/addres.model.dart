import 'dart:convert';

import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class AddRes extends Modifier {
  final List<Ressource> ressources;
  final Map<String, Ressource>? workOnRes;

  AddRes({required this.ressources, this.workOnRes})
      : super(name: "AddRes", description: "Adds a list of Ressource");

  factory AddRes.fromJson(Map<String, dynamic> jsn) {
    final dynamic decodedRessources = jsn['ressources'];
    List<dynamic> resList;
    if (decodedRessources is String) {
      resList = json.decode(decodedRessources) as List;
    } else {
      resList = decodedRessources as List;
    }
    
    List<Ressource> ressourceList = resList.map((i) => Ressource.fromJson(i as Map<String, dynamic>)).toList();
    return AddRes(ressources: ressourceList);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'ressources': json.encode(ressources)
    };
  }

  @override
  void modify() {
    if (workOnRes != null) {
      for (var res in ressources) {
        workOnRes![res.name]?.add(res);
      }
    } else {
      for (var res in ressources) {
        Game.ressources[res.name]?.add(res);
      }
    }
  }

  @override
  String info() {
    return "${super.info()}add: $ressources from $workOnRes";
  }
}
