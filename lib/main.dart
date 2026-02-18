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
    Game.getInstance();
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
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
  bool _dsgvoAccepted = false;
  
  @override
  void initState() {
    super.initState();
    final game = Game.getInstance();
    _lastCelebratedStage = game.stage;
    game.addStageListener(_onStageChanged);
    Game.notifier.addListener(_rebuild);
    
    _checkDSGVO();
  }

  Future<void> _checkDSGVO() async {
    final status = await Game.getInstance().dataManager.readData("dsgvo_accepted");
    if (status == "true") {
      setState(() {
        _dsgvoAccepted = true;
      });
    }
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
        elevation: 0,
        backgroundColor: Colors.white,
        shape: const Border(
          bottom: BorderSide(color: Colors.black, width: 3),
        ),
        toolbarHeight: 80, // AMPLE SPACE FOR TITLE
        centerTitle: true,
        title: const Text(
          'RETTE DIE WELT', 
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 24)
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(135.0), // AMPLE SPACE for Cartoon Dashboard
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: <Widget>[
                      const StageItem(),
                      const SizedBox(width: 16),
                      Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black.withOpacity(0.1), width: 1.5),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, offset: Offset(2, 2), blurRadius: 0),
                              ],
                            ),
                            child: RessourceTable(
                              ressourceList: Game.ressources.values.where((r) => r.name != "Stage").toList(),
                              size: 26.0,
                              isGlobal: true,
                            ),
                          )),
                    ],
                  ),
                ),
                // CLASSIC LARGE TAB BAR
                const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.orange,
                  indicatorWeight: 4,
                  labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                  tabs: [
                    Tab(height: 45, text: "AUFGABEN"),
                    Tab(height: 45, text: "STUFEN"),
                  ],
                ),
              ],
            )
        ),
      ),
      body: const TabBarView(
        children: [
          TaskList(),
          LevelList()
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black, width: 2)),
        ),
        child: BottomAppBar(
            elevation: 0,
            height: 70,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.share, color: Colors.black, size: 26),
                      onPressed: () => shareScreenshot(context)
                  ),
                  const Spacer(),
                  IconButton(
                      icon: const Icon(Icons.replay, color: Colors.red, size: 26),
                      onPressed: () {
                        _lastCelebratedStage = 0;
                        Game.getInstance().resetGame();
                      }
                  ),
                  const Spacer(),
                  // THE DSGVO SHIELD WITH DYNAMIC GREEN CORE
                  IconButton(
                      icon: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_dsgvoAccepted)
                            const Icon(Icons.shield, color: Colors.green, size: 20),
                          const Icon(Icons.shield_outlined, color: Colors.black, size: 30),
                        ],
                      ),
                      onPressed: () async {
                        final result = await showDSGVODialog(context);
                        if (result == ConfirmAGB.ACCEPT) {
                          await Game.getInstance().dataManager.writeJson("dsgvo_accepted", "true");
                          _checkDSGVO();
                        }
                      }
                  ),
                  IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black, size: 30),
                      onPressed: () => showAppAboutDialog(context)
                  )
                ]
            )
        ),
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
