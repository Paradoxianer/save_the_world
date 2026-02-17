import 'package:flutter/material.dart';
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
    game.addStageListener(_refresh);
  }

  @override
  void dispose() {
    // Note: ensure we don't cause issues if removeStageListener is missing
    // Based on current model, we only have addStageListener. 
    // If you add removeStageListener to Game later, call it here.
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.account_balance, // Etwas "cartoonigeres" Icon für die Stufe
            size: widget.size, 
            color: Colors.orange[800]
          ),
          Text(
            "LVL ${game.stage}",
            style: TextStyle(
              fontSize: widget.size * 0.4,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
