import 'dart:async';
import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class AutoExecuteModifier extends Modifier {
  final List<Modifier> modifiers;
  final int intervalMs;

  /// Jede Aktivierung (jeder modify()-Aufruf) startet einen ZUSÄTZLICHEN,
  /// unabhängigen Timer statt den vorherigen zu ersetzen - eine wiederholbare
  /// Aufgabe wie "Strategische Sitzung einberufen" soll bei jeder erneuten
  /// Aktivierung einen weiteren parallelen Generator hinzufügen, wie es ihr
  /// eigener Beschreibungstext verspricht. Alle Timer dieser Instanz werden
  /// gemeinsam gestoppt, sobald der Modifier von seinem Element entfernt wird.
  final List<Timer> _timers = [];

  AutoExecuteModifier({
    required this.modifiers,
    required this.intervalMs,
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
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'modifiers': modifiers.map((m) => m.toJson()).toList(),
      'intervalMs': intervalMs,
    };
  }

  @override
  void modify() {
    // Start a NEW, additional automation - siehe Klassenkommentar zu _timers.
    debugPrint("[AUTOMATION] Starting AutoExecute every $intervalMs ms "
        "(aktive Ketten dieser Aufgabe: ${_timers.length + 1})");
    _timers.add(Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      for (var m in modifiers) {
        m.modify();
      }
    }));
  }

  void _stopTimer() {
    for (final t in _timers) {
      t.cancel();
    }
    _timers.clear();
  }

  // Ensure timer stops if the element is removed (logic to be expanded in Game/Task)
  @override
  int removedFromElement(workedOn) {
    _stopTimer();
    return super.removedFromElement(workedOn);
  }

  @override
  String info() {
    return "Automation: Executes ${modifiers.length} modifiers every ${intervalMs}ms";
  }
}
