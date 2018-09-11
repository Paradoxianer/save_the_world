import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/gameitem.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class GameElement extends GameItem {
  ChangeNotifier notifier;
  List<Modifier> myModifier;

  GameElement({String name, String description, IconData icon,this.myModifier}):
        super(name : name, description : description , icon : icon);

  addModifyer(Modifier modifyThisElement){
    myModifier.add(modifyThisElement);
    modifyThisElement.addedToElement(this);
  }

  removeModifyer(Modifier modifierToRemove){
    myModifier.remove(modifierToRemove);
    modifierToRemove.removedFromElement(this);
  }

  int hasModifyer(Modifier mod){
    return myModifier.indexOf(mod);
  }

  void modify(){
    int listSize = myModifier.length;
    for (int i = 0; i < listSize; i++) {
      myModifier[i].modify();
    }
  }

  addListener(VoidCallback listener) {
    notifier.addListener(listener);
  }

  removeListener(VoidCallback listener) {
    notifier.removeListener(listener);
  }
}