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
    setState(() {
      _dsgvoAccepted = (status == "true");
    });
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
        toolbarHeight: 70,
        centerTitle: true,
        title: const Text(
          'RETTE DIE WELT', 
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 22)
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70.0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: <Widget>[
                  const StageItem(),
                  const VerticalDivider(width: 20, thickness: 2, color: Colors.black12, indent: 10, endIndent: 10),
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black12, width: 1),
                        ),
                        child: RessourceTable(
                          ressourceList: Game.ressources.values.where((r) => r.name != "Stage").toList(),
                          size: 24.0,
                        ),
                      )),
                ],
              ),
            )
        ),
      ),
      body: Container(
        color: const Color(0xFFEEEEEE),
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.orange,
              indicatorWeight: 4,
              tabs: [
                Tab(child: Text("AUFGABEN", style: TextStyle(fontWeight: FontWeight.w900))),
                Tab(child: Text("STUFEN", style: TextStyle(fontWeight: FontWeight.w900))),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  TaskList(),
                  LevelList()
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black, width: 2)),
        ),
        child: BottomAppBar(
            elevation: 0,
            color: Colors.white,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.share, color: Colors.black),
                      onPressed: () => shareScreenshot(context)
                  ),
                  const Spacer(),
                  IconButton(
                      icon: const Icon(Icons.replay, color: Colors.red),
                      onPressed: () {
                        _lastCelebratedStage = 0;
                        Game.getInstance().resetGame();
                      }
                  ),
                  const Spacer(),
                  // DSGVO Icon with dynamic color: Green if accepted, Red if not
                  IconButton(
                      icon: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.shield, color: _dsgvoAccepted ? Colors.green : Colors.red, size: 18),
                          const Icon(Icons.shield_outlined, color: Colors.black, size: 28),
                        ],
                      ),
                      onPressed: () async {
                        final result = await showDSGVODialog(context);
                        if (result == ConfirmAGB.ACCEPT) {
                          await Game.getInstance().dataManager.writeJson("dsgvo_accepted", "true");
                          _checkDSGVO();
                        } else if (result == ConfirmAGB.CANCEL) {
                          await Game.getInstance().dataManager.writeJson("dsgvo_accepted", "false");
                          _checkDSGVO();
                        }
                      }
                  ),
                  IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.black),
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
