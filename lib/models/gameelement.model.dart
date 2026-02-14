import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/gameitem.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class GameElement extends GameItem {
  late ChangeNotifier notifier;
  List<Modifier> myModifier;

  GameElement({
    super.name,
    super.description,
    super.icon,
    List<Modifier>? myModifier,
  }) : myModifier = myModifier ?? [] {
    notifier = ChangeNotifier();
  }

  void addModifyer(Modifier modifyThisElement) {
    myModifier.add(modifyThisElement);
    modifyThisElement.addedToElement(this);
  }

  void removeModifyer(Modifier modifierToRemove) {
    myModifier.remove(modifierToRemove);
    modifierToRemove.removedFromElement(this);
  }

  int hasModifyer(Modifier mod) {
    return myModifier.indexOf(mod);
  }

  void modify() {
    for (var modifier in myModifier) {
      modifier.modify();
    }
  }

  void addListener(VoidCallback listener) {
    notifier.addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    notifier.removeListener(listener);
  }
}
