import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';
import 'package:save_the_world_flutter_app/data/stages/common_tasks.dart';

final Stage stage32 = Stage(
  level: 32,
  member: 8000000000,
  description: "Die Vollendung - Maranatha!",
  activeTasks: ["Bibellesen", "Das letzte Gebet der Menschheit"],
  allTasks: [
    baseBible,
    baseSleep,
    Task(
      name: "Das letzte Gebet der Menschheit",
      description: "Wenn alle Stimmen verstummen und nur noch ein Ruf bleibt: Herr Jesus, komm bald!",
      duration: 5000000.0, // Ein episches Finale, das alles abverlangt
      cost: [
        Faith(value: 50000000.0), 
        Wisdom(value: 10000000.0),
        Member(value: 8000000000.0)
      ],
      modifier: [
        MessageModifier(message: "SIEHE: Er kommt mit den Wolken, und jedes Auge wird ihn sehen!"),
        MessageModifier(message: "GLÜCKWUNSCH: Du hast die Welt in die Arme ihres Schöpfers geführt. Das Spiel ist vollendet."),
      ],
    ),
  ],
);
