import 'package:flutter/foundation.dart';

/// ChangeNotifier mit öffentlichem notify(): notifyListeners() ist in Flutter
/// als @protected/@visibleForTesting markiert und darf nur innerhalb der
/// eigenen Unterklasse aufgerufen werden - Game, GameElement und
/// GameController halten ihre Notifier aber als Felder und lösen sie von
/// außen aus. Diese kleine Unterklasse macht genau das regelkonform.
class GameNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}
