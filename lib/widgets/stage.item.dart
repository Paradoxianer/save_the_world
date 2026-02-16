import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/globals.dart';
import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';

class StageItem extends StatefulWidget {
  final double size;

  const StageItem({super.key, this.size = 30.0});

  @override
  State<StageItem> createState() => StageItemState();
}

class StageItemState extends State<StageItem> {
  late Game game;

  @override
  void initState() {
    super.initState();
    game = Game.getInstance();
    game.addStageListener(valueChanged);
  }

  @override
  void dispose() {
    game.removeListener(valueChanged);
    super.dispose();
  }

  void valueChanged() {
    if (mounted) {
      debugPrint("show the dialog");
      showNewStage(context);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.home, size: widget.size),
        Text(
          game.stage.toString(),
          textScaler: TextScaler.linear(widget.size / 30.0),
        ),
      ],
    );
  }
}

void showNewStage(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        List<int> stageList = levels.keys.toList();
        final currentStage = Game.getInstance().stage;
        final stageTitle = levels[stageList[currentStage]] ?? "Unbekannt";
        final maxMembers = stageList[currentStage].toString();

        return SimpleDialog(
            title: const Text('Gratulation', textAlign: TextAlign.center),
            children: <Widget>[
              const SizedBox(height: 10),
              SizedBox(
                height: 160,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/award.png',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      top: 18, // Perfekte optische Mitte des goldenen Siegels
                      child: Text(
                        currentStage.toString(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text("du bist jetzt eine", textAlign: TextAlign.center),
              ),
              Text(
                "$stageTitle\n",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Dein Limit wurde auf $maxMembers Mitglieder erhöht!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 20),
            ]);
      });
}
