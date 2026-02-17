import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:save_the_world_flutter_app/about.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/widgets/celebration_dialog.dart';
import 'package:save_the_world_flutter_app/widgets/level.list.dart';
import 'package:save_the_world_flutter_app/widgets/ressourcetable.item.dart';
import 'package:save_the_world_flutter_app/widgets/stage.item.dart';
import 'package:save_the_world_flutter_app/widgets/task.list.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey previewContainer = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Initializing game instance
    Game.getInstance();
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      home: DefaultTabController(
        length: 2,
        child: RepaintBoundary(
            key: previewContainer,
            child: Home(previewContainer: previewContainer)
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final GlobalKey previewContainer;

  const Home({super.key, required this.previewContainer});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? _lastCelebratedStage;
  
  @override
  void initState() {
    super.initState();
    final game = Game.getInstance();
    _lastCelebratedStage = game.stage;
    game.addStageListener(_onStageChanged);
    Game.notifier.addListener(_rebuild);
  }

  @override
  void dispose() {
    Game.notifier.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onStageChanged() {
    final game = Game.getInstance();
    if (_lastCelebratedStage != game.stage && game.lastStageDuration != null) {
      _lastCelebratedStage = game.stage;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showCelebration(
            context, 
            game.stage, 
            duration: game.lastStageDuration, 
            clicks: game.lastStageClicks
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(55.0),
            child: Row(
              children: <Widget>[
                const StageItem(),
                Expanded(
                    child: RessourceTable(
                      ressourceList: Game.ressources.values.where((r) => r.name != "Stage").toList(),
                      size: 25.0,
                      isGlobal: true, // IMPORTANT: Mark this as global for feedback keys!
                    )),
              ],
            )
        ),
        title: const Text('Rette die Welt'),
      ),
      body: const TabBarView(
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
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      shareScreenshot(context);
                    }
                ),
                const Spacer(),
                IconButton(
                    icon: const Icon(Icons.replay),
                    onPressed: () {
                      _lastCelebratedStage = 0;
                      Game.getInstance().resetGame();
                    }
                ),
                const Spacer(),
                IconButton(
                    icon: const Icon(Icons.contacts),
                    onPressed: () {
                      showDSGVODialog(context);
                    }
                ),
                IconButton(
                    icon: const Icon(Icons.question_answer),
                    onPressed: () {
                      showAppAboutDialog(context);
                    }
                )
              ]
          )
      ),
    );
  }

  Future<ByteData?> takeScreenShot() async {
    final RenderRepaintBoundary? boundary = widget.previewContainer.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData;
  }

  Future<void> shareScreenshot(BuildContext context) async {
    try {
      final ByteData? bytes = await takeScreenShot();
      if (bytes == null) return;
      
      final Uint8List uint8list = bytes.buffer.asUint8List();
      final box = context.findRenderObject() as RenderBox?;
      
      await Share.shareXFiles(
        [XFile.fromData(uint8list, name: 'Game.png', mimeType: 'image/png')],
        subject: 'Save The World',
        sharePositionOrigin: box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      );
    } catch (e) {
      debugPrint('error sharing screenshot: $e');
    }
  }
}
