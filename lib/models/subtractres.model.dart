import 'dart:convert';

import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class SubtractRes extends Modifier {
  final List<Ressource> ressources;
  final Map<String, Ressource>? workOnRes;

  SubtractRes({List<Ressource>? ressources, this.workOnRes})
      : ressources = ressources ?? [],
        super(name: "SubtractRes", description: "Removes a list of Ressource");

  factory SubtractRes.fromJson(Map<String, dynamic> jsn) {
    final dynamic decodedRessources = jsn['ressources'];
    List<dynamic> resList;
    if (decodedRessources is String) {
      resList = json.decode(decodedRessources) as List;
    } else {
      resList = decodedRessources as List;
    }

    List<Ressource> ressourceList =
        resList.map((i) => Ressource.fromJson(i as Map<String, dynamic>)).toList();
    return SubtractRes(ressources: ressourceList);
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'ressources': json.encode(ressources)};
  }

  @override
  void modify() {
    if (workOnRes != null) {
      for (var res in ressources) {
        workOnRes![res.name]?.subtract(res);
      }
    } else {
      for (var res in ressources) {
        Game.ressources[res.name]?.subtract(res);
      }
    }
  }

  @override
  String info() {
    return "${super.info()}subtract: $ressources from $workOnRes";
  }
}
