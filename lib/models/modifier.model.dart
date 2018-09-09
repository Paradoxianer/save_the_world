import 'package:save_the_world_flutter_app/models/gameelement.model.dart';
import 'package:save_the_world_flutter_app/models/gameitem.model.dart';

class Modifier extends GameItem {
  GameElement workOnItem;
  GameElement elementToWorkWith;

  Modifier({this.workOnItem,this.elementToWorkWith}){
    this.addedToElement(workOnItem);
  }

  modify(){}

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