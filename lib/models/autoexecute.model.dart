import 'dart:async';
import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class AutoExecuteModifier extends Modifier {
  final List<Modifier> modifiers;
  final int intervalMs;

  /// Wie oft diese Automatisierung aktiviert wurde. Eine wiederholbare
  /// Aufgabe wie "Strategische Sitzung einberufen" soll bei jeder erneuten
  /// Aktivierung den Ertrag vervielfachen ("noch ein Generator"). Statt dafür
  /// pro Aktivierung einen weiteren echten Timer zu registrieren - bei
  /// hunderten Aktivierungen hunderte parallel laufende Timer, schlecht für
  /// Akku/Performance auf dem Handy - wendet EIN EINZIGER Timer pro Tick die
  /// Modifier-Liste activationCount-mal an. Wirtschaftlich identisch zu N
  /// parallelen Timern, technisch konstanter Aufwand. Wird mitgespeichert,
  /// damit der Ausbaustand einen Neustart der App überlebt.
  int activationCount;
  Timer? _timer;

  AutoExecuteModifier({
    required this.modifiers,
    required this.intervalMs,
    this.activationCount = 0,
  }) : super(
          name: "AutoExecuteModifier",
          description: "Executes a list of modifiers periodically.",
        );

  factory AutoExecuteModifier.fromJson(Map<String, dynamic> jsn) {
    var mList = jsn['modifiers'] as List;
    List<Modifier> mods = mList.map((i) => Modifier.fromJson(i as Map<String, dynamic>)).toList();
    return AutoExecuteModifier(
      modifiers: mods,
      intervalMs: jsn['intervalMs'] as int,
      activationCount: (jsn['activationCount'] as int?) ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'modifiers': modifiers.map((m) => m.toJson()).toList(),
      'intervalMs': intervalMs,
      'activationCount': activationCount,
    };
  }

  @override
  void modify() {
    activationCount++;
    if (_timer != null) return; // laeuft schon - der naechste Tick nutzt den neuen Zaehlerstand
    debugPrint("[AUTOMATION] Starting AutoExecute every $intervalMs ms");
    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      for (int i = 0; i < activationCount; i++) {
        for (var m in modifiers) {
          m.modify();
        }
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Für Game.resetGame()/jumpToStage(): diese Instanz lebt auf dem
  /// statischen Stage-Objekt (allStages) und wird von initStage() direkt
  /// wiederverwendet, nicht neu erzeugt - ohne expliziten Reset würde ein
  /// neues Spiel den Ausbaustand aus einem vorherigen Durchlauf im selben
  /// App-Prozess erben.
  void resetActivation() {
    _stopTimer();
    activationCount = 0;
  }

  // Ensure timer stops if the element is removed (logic to be expanded in Game/Task)
  @override
  int removedFromElement(workedOn) {
    _stopTimer();
    return super.removedFromElement(workedOn);
  }

  @override
  String info() {
    return "Automation: Executes ${modifiers.length} modifiers every ${intervalMs}ms (x$activationCount)";
  }
}
