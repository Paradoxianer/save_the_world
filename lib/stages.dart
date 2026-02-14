import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/data/stages/stages_intro.dart';

// This file now acts as a central registry for all game stages.
// The actual data is moved to modular files in lib/data/stages/
// to keep the project maintainable as we scale to 32 stages.

final List<Stage> allStages = <Stage>[
  ...introStages,
  // Future stages will be added here as we expand:
  // ...growthStages,
  // ...movementStages,
  // ...globalStages,
];
