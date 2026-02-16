import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_0.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_1.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_2.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_3.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_4.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_5.dart';
import 'package:save_the_world_flutter_app/data/stages/stages_growth.dart';
import 'package:save_the_world_flutter_app/data/stages/stages_movement.dart';
import 'package:save_the_world_flutter_app/data/stages/stages_global.dart';

// This file acts as a central registry for all game stages.
// Now using a modular approach: one stage per file or logical block.

final List<Stage> allStages = <Stage>[
  stage0,            // Stage 0: Tutorial
  stage1,            // Stage 1: Gemeinschaftsgruppe
  stage2,            // Stage 2: Kleine Gemeinde
  stage3,            // Stage 3: Mittlere Gemeinde
  stage4,            // Stage 4: Mittelgroße Gemeinde
  stage5,            // Stage 5: Große Gemeinde
  ...growthStages,   // Stages 6 - 10 (To be modularized next)
  ...movementStages, // Stages 11 - 20
  ...globalStages,   // Stages 21 - 32
];
