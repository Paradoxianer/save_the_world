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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.15), width: 1.5),
        boxShadow: const [
          // Matching the inset bevel effect of RessourceItem
          BoxShadow(color: Colors.black12, offset: Offset(1.5, 1.5), blurRadius: 0, spreadRadius: 0),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: [
              // Icon Shadow for depth
              Positioned(
                top: 1.5,
                left: 1.5,
                child: Icon(Icons.account_balance, size: widget.size, color: Colors.black12),
              ),
              Icon(
                Icons.account_balance, 
                size: widget.size, 
                color: Colors.blueAccent[700],
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            "LVL ${game.stage}",
            style: TextStyle(
              fontSize: widget.size * 0.45,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
              letterSpacing: 0.5,
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
