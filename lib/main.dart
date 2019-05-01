import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:save_the_world_flutter_app/about.dart';
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
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('de'), // Hebrew
        // ... other locales the app supports
      ],
      home: DefaultTabController(
        length: 2,
        child: RepaintBoundary(
            key: previewContainer,
            child: Home(previewContainer)
        ),
      ),
    );
  }

}

class Home extends StatelessWidget {
  GlobalKey previewContainer;

  Home(GlobalKey key) {
    previewContainer = key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ],
            )
        ),
        title: Text('Rette die Welt'),
      ),
      body: TabBarView(
        children: [
          TaskList(),
          LevelList()
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      shareScreenshot();
                    }
                ),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.replay),
                    onPressed: () {
                      Game.getInstance().initRes();
                    }
                ),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.contacts),
                    onPressed: () {
                      showDSGVODialog(context);
                    }
                ),
                IconButton(
                    icon: Icon(Icons.question_answer),
                    onPressed: () {
                      showAppAboutDialog(context);
                    }
                )

              ]
          )
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

/* Future<ConfirmAGB> _asyncConfirmDSGVO(BuildContext context) async {
    return showDialog<ConfirmAGB>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Stimmst du den AGB und DSGVO zu?'),
          content: const Text(
              "Diese App wurde von Paradoxon aka Matthias Lindner geschrieben." +
                  /*"Kontaktdaten des Anbieters"
              Für welche Daten des Nutzers benötigt die App welche Zugriffsrechte?
              Wie lange werden diese Daten gespeichert?
              Wir das Nutzungsverhalten/ die Daten der Nutzer durch Traking Tools (Apptrace, Apptrace, Adeven, App Annie, Google Analytics für Apps) ausgewertet?
            Werden die Daten an Dritte übertragen, wenn ja zu welchem Zweck?
        Welche Rechte hat der Nutzer bezüglich Löschen, Sperren und Berichtigen seiner Daten?
        Wie kann der Nutzer widersprechen?*/
                  "Wir die Appentwickler haben begründetes \n" +
                  "Interesses (s. Art. 6 Abs. 1 lit. f. DSGVO) Daten in Form von Screenshots der App\n" +
                  "zu erheben und innerhalb der App zu speichern. Die App stellt diese dann," +
                  "soweit es von Ihnen gewollt wird, über soziale Medien zur Verfügung. Dafür wird die Android" +
                  "internes Social Media Plugin benutzt."
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAGB.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('Ich stimme zu'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAGB.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }*/
}