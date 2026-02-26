import 'package:save_the_world_flutter_app/models/task.model.dart';
import 'package:save_the_world_flutter_app/models/stage.model.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';
import 'package:save_the_world_flutter_app/models/addtask.model.dart';
import 'package:save_the_world_flutter_app/models/removetask.model.dart';
import 'package:save_the_world_flutter_app/models/setmax.model.dart';
import 'package:save_the_world_flutter_app/models/setmin.model.dart';
import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';
import 'package:save_the_world_flutter_app/models/AddToRandom.model.dart';
import 'package:save_the_world_flutter_app/models/message.modifier.dart';
import 'package:save_the_world_flutter_app/models/removemodifier.model.dart';

class StageExportUtils {
  static String exportLibrary(List<Task> libraryTasks) {
    final buffer = StringBuffer();
    buffer.writeln("import 'package:save_the_world_flutter_app/models/addtask.model.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/message.modifier.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/removetask.model.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/subtractres.model.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/task.model.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/AddToRandom.model.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/setmax.model.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/setmin.model.dart';");
    buffer.writeln("import 'package:save_the_world_flutter_app/models/autoexecute.model.dart';");
    buffer.writeln();
    buffer.writeln('// --- AUTO-GENERATED LIBRARY EXPORT ---');
    for (var t in libraryTasks) {
      String varName = t.name.replaceAll(" ", "").replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      varName = varName.replaceAll('ä', 'ae').replaceAll('ö', 'oe').replaceAll('ü', 'ue').replaceAll('ß', 'ss');
      
      buffer.writeln('final Task $varName = Task(');
      buffer.writeln('  name: "${t.name}",');
      buffer.writeln('  description: "${t.description}",');
      buffer.writeln('  duration: ${t.duration},');
      buffer.writeln('  timeToSolve: ${t.timeToSolve == double.infinity ? 'double.infinity' : t.timeToSolve},');
      buffer.writeln('  isMilestone: ${t.isMilestone},');
      buffer.writeln('  cost: [${_exportResources(t.cost)}],');
      buffer.writeln('  award: [${_exportResources(t.award)}], ');
      
      final modStr = _exportModifiers(t.myModifier ?? []);
      if (modStr.isNotEmpty) buffer.writeln('  modifier: [$modStr], ');
      
      final onStr = _exportModifiers(t.online ?? []);
      if (onStr.isNotEmpty) buffer.writeln('  online: [$onStr], ');
      
      final missStr = _exportModifiers(t.missed ?? []);
      if (missStr.isNotEmpty) buffer.writeln('  missed: [$missStr], ');
      
      buffer.writeln(');');
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String exportStage(Stage currentStage, List<String> activeTasks, List<String> randomTasks, List<Task> allStageTasks) {
    final buffer = StringBuffer();
    buffer.writeln('// --- STAGE EXPORT ---');
    buffer.writeln('final Stage stage${currentStage.level} = Stage(');
    buffer.writeln('  level: ${currentStage.level},');
    buffer.writeln('  description: "${currentStage.description}",');
    buffer.writeln('  activeTasks: ${_formatStringList(activeTasks)},');
    buffer.writeln('  randomTasks: ${_formatStringList(randomTasks)},');
    buffer.writeln('  allTasks: [');
    for (var t in allStageTasks) {
      buffer.writeln('    Task( ');
      buffer.writeln('      name: "${t.name}",');
      buffer.writeln('      description: "${t.description}",');
      buffer.writeln('      duration: ${t.duration},');
      buffer.writeln('      timeToSolve: ${t.timeToSolve == double.infinity ? 'double.infinity' : t.timeToSolve},');
      buffer.writeln('      isMilestone: ${t.isMilestone},');
      buffer.writeln('      cost: [${_exportResources(t.cost)}],');
      buffer.writeln('      award: [${_exportResources(t.award)}],');
      final modStr = _exportModifiers(t.myModifier ?? []);
      if (modStr.isNotEmpty) buffer.writeln('      modifier: [$modStr], ');
      final onStr = _exportModifiers(t.online ?? []);
      if (onStr.isNotEmpty) buffer.writeln('      online: [$onStr], ');
      final missStr = _exportModifiers(t.missed ?? []);
      if (missStr.isNotEmpty) buffer.writeln('      missed: [$missStr], ');
      buffer.writeln('    ),');
    }
    buffer.writeln('  ],');
    buffer.writeln(');');
    return buffer.toString();
  }

  static String _formatStringList(List<String>? l) => (l == null || l.isEmpty) ? '[]' : '[${l.map((e) => "\"$e\"").join(', ')}]';
  
  static String _exportResources(List<Ressource> list) {
    return list.map((res) {
       final multiplier = res.multiplierResourceName != null 
          ? ', multiplierResourceName: "${res.multiplierResourceName}", multiplierValue: ${res.multiplierValue}' 
          : '';
       return '${res.name}(value: ${res.value}$multiplier)';
    }).join(', ');
  }
  
  static String _exportModifiers(List<Modifier> list) {
    return list.map((m) {
      final String taskName = (m is AddTask) ? m.nameOfTask : ((m is RemoveTask) ? m.nameOfTask : ((m is AddToRandom) ? m.nameOfTask : ""));
      if (m is AddTask) return 'AddTask(task: "$taskName")';
      if (m is RemoveTask) return 'RemoveTask(task: "$taskName")';
      if (m is AddToRandom) return 'AddToRandom(task: "$taskName")';
      if (m is SetMax) return 'SetMax(ressource: "${m.workOn}", newMax: ${m.newMax})';
      if (m is SetMin) return 'SetMin(ressource: "${m.workOn}", newMin: ${m.newMin})';
      if (m is MessageModifier) return 'MessageModifier(message: "${m.message}")';
      if (m is RemoveModifer) return 'RemoveModifer(nameOfTask: "$taskName", modifier: [])';
      if (m is AutoExecuteModifier) return 'AutoExecuteModifier(modifiers: [${_exportModifiers(m.modifiers)}], intervalMs: ${m.intervalMs})';
      return null;
    }).where((e) => e != null).join(', ');
  }
}
