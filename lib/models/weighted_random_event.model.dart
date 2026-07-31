/// Konfiguration für ein ressourcenabhängiges Zufallsevent (siehe AddToRandom).
/// Die Feuerchance pro Roll ist `resVal / threshold`, gedeckelt auf 1.0 - ab
/// `threshold` ist das Event also (fast) garantiert, darunter proportional
/// seltener.
class WeightedRandomEvent {
  final String resourceName;
  final double threshold;

  const WeightedRandomEvent({required this.resourceName, required this.threshold});
}
