import 'package:save_the_world_flutter_app/models/addmodifier.model.dart';
import 'package:save_the_world_flutter_app/models/addres.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/gameitem.model.dart';
import 'package:save_the_world_flutter_app/models/removemodifier.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/starttaks.model.dart';
import 'package:save_the_world_flutter_app/models/stoptaks.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';

class Modifier extends GameItem {
  GameElement workOnItem;

  Modifier({String name, String description, GameElement workOnItem}) :
        super(icon: null, name: name, description: description) {
    this.workOnItem = workOnItem;
    this.addedToElement(workOnItem);
  }

  factory Modifier.fromJson(Map<String, dynamic> jsn){
    String whatModifier = jsn['name'];
    switch (whatModifier) {
      case "AddRes":
        return AddRes.fromJson(jsn);
        break;
      case "SubtractRes":
        return SubtractRes.fromJson(jsn);
        break;
      case "AddTask":
        return AddTask.fromJson(jsn);
        break;
      case "RemoveTask":
        return RemoveTask.fromJson(jsn);
        break;
      case "AddModifier":
        return AddModifer.fromJson(jsn);
        break;
      case "RemoveModifier":
        return RemoveModifer();
        break;
      case "AddMissed":
        return null;
        break;
      case "RemoveMissed":
        return null;
        break;
      case "StopTask":
        return StopTask();
        break;
      case "StartTask":
        return StartTask();
        break;
      case "NewDuration":
        return null;
        break;
      case "RemoveMissed":
        return null;
        break;
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
    };
  }

  modify() {}

  addedToElement(GameElement workOn){
    if (workOnItem != null) {
      removedFromElement(workOnItem);
    }
    workOnItem=workOn;
  }

  int removedFromElement(GameElement workedOn){
    if (workedOn!=workOnItem)
      return -1;
    else{
      //make shure it is removed from the gameElement
      if (workedOn.hasModifyer(this)>=0)
        workedOn.removeModifyer(this);
      workOnItem=null;
      return 0;
    }
  }
}