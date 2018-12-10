import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/level.list.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';
import 'package:save_the_world_flutter_app/widgets/stage.item.dart';
import 'package:save_the_world_flutter_app/widgets/task.list.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  GlobalKey previewContainer = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    Game game = Game.getInstance();
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: RepaintBoundary(
          key: previewContainer,
          child: Scaffold(
            appBar: AppBar(
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: Row(
                    children: <Widget>[
                      StageItem(),
                      Expanded(
                          child: RessourceTable(
                            ressourceList: Game.ressources.values.toList(),
                            size: 25.0,
                          )),
                      IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            shareScreenshot();
                          })
                    ],
                  )),
              title: Text('Rette die Welt'),
            ),
            body: TabBarView(
              children: [
                TaskList(),
                LevelList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  takeScreenShot() async {
    debugPrint("taking a screenshot");
    RenderRepaintBoundary boundary = previewContainer.currentContext
        .findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    debugPrint("screenhot is" + byteData.toString());
    return byteData;
  }

  Future shareScreenshot() async {
    try {
      final ByteData bytes = await takeScreenShot();
      debugPrint("now we can share the screenshot");
      await EsysFlutterShare.shareImage(
          'Game.png', bytes, 'Save The World');
    } catch (e) {
      print('error: $e');
    }
  }
}
