import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/data/stages/stages_intro.dart';
import 'package:save_the_world_flutter_app/data/stages/stages_growth.dart';

// This file acts as a central registry for all game stages.
// Data is modularized to keep the project maintainable.

final List<Stage> allStages = <Stage>[
  ...introStages,   // Stages 0 - 3 (The Family / Clan)
  ...growthStages,  // Stages 4 - 10 (The Church / Small Community)
  // Future stages:
  // ...movementStages,
  // ...globalStages,
];
