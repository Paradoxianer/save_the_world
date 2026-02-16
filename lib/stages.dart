import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_0.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_1.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_2.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_3.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_4.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_5.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_6.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_7.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_8.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_9.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_10.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_11.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_12.dart';
import 'package:save_the_world_flutter_app/data/stages/stage_13.dart';
import 'package:save_the_world_flutter_app/data/stages/stages_growth.dart';
import 'package:save_the_world_flutter_app/data/stages/stages_movement.dart';
import 'package:save_the_world_flutter_app/data/stages/stages_global.dart';

// This file acts as a central registry for all game stages.
// Now using a fully modular approach: one stage per file.

final List<Stage> allStages = <Stage>[
  stage0, stage1, stage2, stage3, stage4, stage5, stage6, stage7, stage8, stage9,
  stage10, stage11, stage12, stage13,
  ...growthStages,   // Remaining growth stages (if any)
  ...movementStages, // Stages 14 - 20
  ...globalStages,   // Stages 21 - 32
];
