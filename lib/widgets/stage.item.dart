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

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          // Inner shadow effect to make it look "inset" (eingelassen)
          BoxShadow(color: Colors.black12, offset: Offset(2, 2), blurRadius: 0, spreadRadius: 0),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: [
              // Shadow for the Icon
              Positioned(
                top: 2,
                left: 2,
                child: Icon(Icons.account_balance, size: widget.size, color: Colors.black26),
              ),
              Icon(
                Icons.account_balance, 
                size: widget.size, 
                color: Colors.blueAccent[700],
              ),
            ],
          ),
          Text(
            "LVL ${game.stage}",
            style: TextStyle(
              fontSize: widget.size * 0.45,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              shadows: const [
                Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
