import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressource.item.dart';

class RessourceTable extends StatelessWidget {

  final List<Ressource> ressourceList;
  final int rows = 2;
  double size;
  int column = 0;


  RessourceTable({this.ressourceList,this.size=20.0});

  @override
  Widget build(BuildContext context) {
    List<TableRow> list = new List<TableRow>();
    if (ressourceList != null) {
      if (ressourceList.length <= 1)
        column = 1;
      else
        column = ((ressourceList.length / rows) +
            (ressourceList.length % rows / ressourceList.length % rows)).ceil();
      for (var i = 0; i < rows; i++) {
        list.add(returnRow(i));
      }
    }
    return Table(
        defaultColumnWidth: FixedColumnWidth(size+5.0),
        children: list
    );
  }

  TableRow returnRow(row){
    List<Widget> list = new List<Widget>();
    int start = row*column;
    int end = start + column;
    for(var i =  start; i < end; i++){
      if (i<ressourceList.length)
        list.add(new RessourceItem(ressourceList[i],size));
      else
        list.add(new Text(""));
    }
    return new TableRow(children: list);
  }

}