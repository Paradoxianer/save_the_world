import 'package:flutter/material.dart';
import 'package:save_the_world_flutter_app/models/ressource.model.dart';
import 'package:save_the_world_flutter_app/models/faith.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/member.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/money.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/publicity.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/time.ressource.model.dart';
import 'package:save_the_world_flutter_app/models/wisdome.ressource.model.dart';

class ResourceEditorSection extends StatelessWidget {
  final String title;
  final List<Ressource> resources;
  final Color color;
  final VoidCallback onUpdate;

  const ResourceEditorSection({
    super.key,
    required this.title,
    required this.resources,
    required this.color,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.amber),
              onPressed: () => _showAddResourceDialog(context),
            ),
          ],
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: resources.map((res) => _buildResourceCard(context, res)).toList(),
        ),
      ],
    );
  }

  Widget _buildResourceCard(BuildContext context, Ressource res) {
    final isMultiplied = res.multiplierResourceName != null;
    return Card(
      color: Colors.white.withOpacity(0.03),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(res.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                IconButton(
                  icon: const Icon(Icons.delete, size: 14),
                  onPressed: () {
                    resources.remove(res);
                    onUpdate();
                  },
                ),
              ],
            ),
            _buildNumberField(
              'Wert',
              res.value.toString(),
              (v) {
                res.value = double.tryParse(v) ?? 0;
                onUpdate();
              },
            ),
            if (isMultiplied) ...[
              const SizedBox(height: 8),
              _buildResourceDropdown(
                res.multiplierResourceName!,
                (v) {
                  res.multiplierResourceName = v;
                  onUpdate();
                },
              ),
              _buildNumberField(
                'Faktor',
                res.multiplierValue.toString(),
                (v) {
                  res.multiplierValue = double.tryParse(v) ?? 1.0;
                  onUpdate();
                },
              ),
            ],
            TextButton(
              onPressed: () {
                if (res.multiplierResourceName == null) {
                  res.multiplierResourceName = "Member";
                  res.multiplierValue = 1.0;
                } else {
                  res.multiplierResourceName = null;
                  res.multiplierValue = null;
                }
                onUpdate();
              },
              child: Text(
                isMultiplied ? 'Abhängigkeit weg' : 'Abhängigkeit +',
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, String initial, Function(String) onChanged) {
    return TextFormField(
      initialValue: initial,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true),
      onChanged: onChanged,
    );
  }

  Widget _buildResourceDropdown(String current, Function(String?) onChanged) {
    final types = ["Faith", "Member", "Money", "Publicity", "Time", "Wisdom"];
    return DropdownButtonFormField<String>(
      isDense: true,
      value: types.contains(current) ? current : null,
      decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(8), border: OutlineInputBorder()),
      items: types.map((n) => DropdownMenuItem(value: n, child: Text(n, style: const TextStyle(fontSize: 11)))).toList(),
      onChanged: onChanged,
    );
  }

  void _showAddResourceDialog(BuildContext context) {
    final types = ["Faith", "Member", "Money", "Publicity", "Time", "Wisdom"];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ressourcentyp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: types.map((type) => ListTile(
            title: Text(type),
            onTap: () {
              resources.add(_createResourceInstance(type));
              onUpdate();
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  Ressource _createResourceInstance(String type) {
    switch (type) {
      case "Faith": return Faith(value: 0);
      case "Member": return Member(value: 0);
      case "Money": return Money(value: 0);
      case "Publicity": return Publicity(value: 0);
      case "Time": return Time(value: 0);
      case "Wisdom": return Wisdom(value: 0);
      default: return Ressource(name: type, value: 0);
    }
  }
}
