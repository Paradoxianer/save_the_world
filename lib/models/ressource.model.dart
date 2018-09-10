import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class Ressource extends GameElement {
  double min = 0.0;
  double value;
  double max = 100.0;
  ChangeNotifier notifier;

  Ressource ({String name,String description, IconData icon,this.value,List<Modifier> modifier}) :
    super(name: name,description : description, icon : icon){
    notifier=new ChangeNotifier();
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

  addListener(VoidCallback listener){
    notifier.addListener(listener);
  }

  removeListener(VoidCallback listener){
    notifier.removeListener(listener);
  }
}