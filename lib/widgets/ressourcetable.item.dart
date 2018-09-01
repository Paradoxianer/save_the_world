import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/ressource.item.dart';

class RessourceTable extends StatelessWidget {

  final List<Ressource> ressourceList;
  final int rows = 2;
  int column = 0;

  RessourceTable({this.ressourceList});

  @override
  Widget build(BuildContext context) {
    column = ((ressourceList.length/rows) + (ressourceList.length % rows / ressourceList.length % rows)).ceil();
    List<TableRow> list = new List<TableRow>();
    for (var i =0; i<rows;i++) {
      list.add(returnRow(i));
    }
    return Table(
        children: list
    );
  }

  TableRow returnRow(row){
    List<Widget> list = new List<Widget>();
    int start = row*column;
    int end = start + column;
    for(var i =  start; i < end; i++){
      if (i<ressourceList.length)
        list.add(new RessourceItem(ressourceList[i]));
      else
        list.add(new Text(""));
    }
    return new TableRow(children: list);
  }

}