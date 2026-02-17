import 'package:save_the_world_flutter_app/models/addmodifier.model.dart';
import 'package:save_the_world_flutter_app/models/addres.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/gameitem.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/multiplyres.model.dart';
import 'package:save_the_world_flutter_app/models/removemodifier.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/setmin.model.dart';
import 'package:save_the_world_flutter_app/models/starttaks.model.dart';
import 'package:save_the_world_flutter_app/models/stoptaks.model.dart';
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';

class Modifier extends GameItem {
  GameElement? workOnItem;

  Modifier({super.name, super.description, this.workOnItem}) : super(icon: null) {
    if (workOnItem != null) {
      addedToElement(workOnItem!);
    }
  }

  factory Modifier.fromJson(Map<String, dynamic>? jsn) {
    if (jsn == null) return Modifier(name: "Unknown", description: "Null data");
    
    String? type = jsn['name'];
    switch (type) {
      case "AddRes":
        return AddRes.fromJson(jsn);
      case "SubtractRes":
        return SubtractRes.fromJson(jsn);
      case "AddTask":
        return AddTask.fromJson(jsn);
      case "RemoveTask":
        return RemoveTask.fromJson(jsn);
      case "AddModifier":
        return AddModifer.fromJson(jsn);
      case "RemoveModifier":
        return RemoveModifer.fromJson(jsn);
      case "StopTask":
        return StopTask.fromJson(jsn);
      case "StartTask":
        return StartTask.fromJson(jsn);
      case "MessageModifier":
        return MessageModifier.fromJson(jsn);
      case "MultiplyRes":
        return MultiplyRes.fromJson(jsn);
      case "AutoExecuteModifier":
        return AutoExecuteModifier.fromJson(jsn);
      case "SetMax":
        return SetMax.fromJson(jsn);
      case "SetMin":
        return SetMin.fromJson(jsn);
      default:
        return Modifier(name: type ?? "Unknown", description: "Generic Modifier");
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
    };
  }

  void modify() {}

  void addedToElement(GameElement workOn) {
    if (workOnItem != null && workOnItem != workOn) {
      removedFromElement(workOnItem!);
    }
    workOnItem = workOn;
  }

  int removedFromElement(GameElement workedOn) {
    if (workedOn != workOnItem) {
      return -1;
    } else {
      if (workedOn.hasModifyer(this) >= 0) {
        workedOn.removeModifyer(this);
      }
      workOnItem = null;
      return 0;
    }
  }

  String info() {
    return "";
  }
}
