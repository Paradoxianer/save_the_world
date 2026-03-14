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
import 'package:save_the_world_flutter_app/models/subtractres.model.dart';

class StageExportUtils {
  // Mapping für stabile Variablennamen in der common_tasks.dart
  static const Map<String, String> _libraryNameMapping = {
    "Schlafen": "baseSleep",
    "Freizeit": "baseFreeTime",
    "Bibellesen": "baseBible",
    "Kollekte": "collectMoney",
    "Der Heilige Geist möchte wirken": "holySpiritWorking",
    "Beerdigung eines Generals": "funeralGeneral",
    "Heiratsvorbereitung 1": "weddingPhase1",
    "Heiratsvorbereitung 2": "weddingPhase2",
    "Hochzeit": "actualWedding",
    "Jemand möchte heiraten": "someoneWantsToMarry",
    
    // Neue Questreihe (Editor-Export Namen beibehalten)
    "Ehevorbereitung 1": "Ehevorbereitung1",
    "Ehevorbereitung 2": "Ehevorbereitung2",
    "Ehevorbereitung 3": "Ehevorbereitung3",
    "Ehevorbereitung 4": "Ehevorbereitung4",
    "Ehevorbereitung 5": "Ehevorbereitung5",
    "Hochzeitsvorbereitung": "Hochzeitsvorbereitung",
  };

  static String exportLibrary(List<Task> libraryTasks) {
    final buffer = StringBuffer();
    _writeImports(buffer);
    buffer.writeln('// --- AUTO-GENERATED LIBRARY EXPORT ---');
    for (var t in libraryTasks) {
      String varName = _libraryNameMapping[t.name] ?? 
                       t.name.replaceAll(" ", "").replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                             .replaceAll('ä', 'ae').replaceAll('ö', 'oe').replaceAll('ü', 'ue').replaceAll('ß', 'ss');
      
      buffer.writeln('final Task $varName = Task(');
      buffer.writeln('  name: "${t.name}",');
      buffer.writeln('  description: "${t.description}",');
      buffer.writeln('  duration: ${t.duration},');
      if (t.timeToSolve != double.infinity) buffer.writeln('  timeToSolve: ${t.timeToSolve},');
      buffer.writeln('  isMilestone: ${t.isMilestone},');
      buffer.writeln('  cost: [${_exportResources(t.cost)}],');
      buffer.writeln('  award: [${_exportResources(t.award)}], ');
      _writeModifiers(buffer, t);
      buffer.writeln(');');
      buffer.writeln();
    }
    return buffer.toString();
  }

  static String exportStage(Stage currentStage, List<String> activeTasks, List<String> randomTasks, List<Task> allStageTasks, {required List<Task> libraryTasks, String? description, int? member}) {
    final buffer = StringBuffer();
    buffer.writeln('// --- STAGE EXPORT ---');
    buffer.writeln('final Stage stage${currentStage.level} = Stage(');
    buffer.writeln('  level: ${currentStage.level},');
    buffer.writeln('  member: ${member ?? currentStage.member},');
    buffer.writeln('  description: "${description ?? currentStage.description}",');
    buffer.writeln('  activeTasks: ${_formatStringList(activeTasks)},');
    buffer.writeln('  randomTasks: ${_formatStringList(randomTasks)},');
    buffer.writeln('  allTasks: [');
    for (var t in allStageTasks) {
      // Prüfe ob der Task EXAKT so in der Library existiert (Referenz-Check)
      bool isLibraryRef = libraryTasks.any((libTask) => 
        libTask.name == t.name && 
        libTask.description == t.description &&
        libTask.duration == t.duration &&
        _exportModifiers(libTask.myModifier) == _exportModifiers(t.myModifier)
      );

      if (isLibraryRef && _libraryNameMapping.containsKey(t.name)) {
        buffer.writeln('    ${_libraryNameMapping[t.name]},');
      } else {
        buffer.writeln('    Task( ');
        buffer.writeln('      name: "${t.name}",');
        buffer.writeln('      description: "${t.description}",');
        buffer.writeln('      duration: ${t.duration},');
        if (t.timeToSolve != double.infinity) buffer.writeln('      timeToSolve: ${t.timeToSolve},');
        buffer.writeln('      isMilestone: ${t.isMilestone},');
        buffer.writeln('      cost: [${_exportResources(t.cost)}],');
        buffer.writeln('      award: [${_exportResources(t.award)}],');
        _writeModifiers(buffer, t, indent: '      ');
        buffer.writeln('    ),');
      }
    }
    buffer.writeln('  ],');
    buffer.writeln(');');
    return buffer.toString();
  }

  static void _writeImports(StringBuffer buffer) {
    const imports = [
      'addtask.model.dart', 'removetask.model.dart', 'setmax.model.dart', 'setmin.model.dart',
      'autoexecute.model.dart', 'AddToRandom.model.dart', 'message.modifier.dart',
      'removemodifier.model.dart', 'subtractres.model.dart', 'task.model.dart',
      'faith.ressource.model.dart', 'member.ressource.model.dart', 'money.ressource.model.dart',
      'publicity.ressource.model.dart', 'time.ressource.model.dart', 'wisdome.ressource.model.dart'
    ];
    for (var imp in imports) {
      buffer.writeln("import 'package:save_the_world_flutter_app/models/$imp';");
    }
    buffer.writeln();
  }

  static void _writeModifiers(StringBuffer buffer, Task t, {String indent = '  '}) {
    final modStr = _exportModifiers(t.myModifier ?? []);
    if (modStr.isNotEmpty) buffer.writeln('${indent}modifier: [$modStr], ');
    final onStr = _exportModifiers(t.online ?? []);
    if (onStr.isNotEmpty) buffer.writeln('${indent}online: [$onStr], ');
    final missStr = _exportModifiers(t.missed ?? []);
    if (missStr.isNotEmpty) buffer.writeln('${indent}missed: [$missStr], ');
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
      if (m is SubtractRes) return 'SubtractRes(ressources: [${_exportResources(m.ressources)}])';
      return null;
    }).where((e) => e != null).join(', ');
  }
}
