import 'package:save_the_world_flutter_app/models/ressource.model.dart';

class Task {
  final List<Ressource> cost;
  final List<Ressource> award;
  final List<Ressource> require;

  const Task({this.cost, this.award,this.require});
}