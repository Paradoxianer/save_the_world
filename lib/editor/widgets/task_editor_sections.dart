import 'package:flutter/material.dart';

class EditorTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String) onChanged;
  final bool isNumber;
  final int maxLines;

  const EditorTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    this.isNumber = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.amber,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}

class CrisisEditorSection extends StatelessWidget {
  final bool isCrisis;
  final TextEditingController timeToSolveController;
  final Function(bool) onToggle;
  final Function(String) onTimeChanged;

  const CrisisEditorSection({
    super.key,
    required this.isCrisis,
    required this.timeToSolveController,
    required this.onToggle,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCrisis ? Colors.red.withOpacity(0.05) : Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isCrisis ? Colors.redAccent.withOpacity(0.3) : Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'KRISEN-MODUS (COUNTDOWN)',
                style: TextStyle(
                  color: isCrisis ? Colors.redAccent : Colors.white38,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Switch(
                value: isCrisis,
                activeColor: Colors.redAccent,
                onChanged: onToggle,
              ),
            ],
          ),
          if (isCrisis) ...[
            const SizedBox(height: 12),
            EditorTextField(
              label: 'Zeit bis Fail (ms)',
              controller: timeToSolveController,
              onChanged: onTimeChanged,
              isNumber: true,
            ),
          ],
        ],
      ),
    );
  }
}
