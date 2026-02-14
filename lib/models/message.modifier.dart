import 'package:save_the_world_flutter_app/models/game.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/modifier.model.dart';

class MessageModifier extends Modifier {
  final String message;

  MessageModifier({required this.message})
      : super(
          name: "MessageModifier",
          description: "Zeigt eine Informationsnachricht als Snackbar an.",
        );

  factory MessageModifier.fromJson(Map<String, dynamic> json) {
    return MessageModifier(message: json['message'] as String);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'message': message,
    };
  }

  @override
  void modify() {
    // Wir setzen die Nachricht im Game-Singleton, 
    // was automatisch den Notifier triggert.
    Game.getInstance().snackbarMessage = message;
  }

  @override
  String info() {
    return "Info: $message";
  }
}
