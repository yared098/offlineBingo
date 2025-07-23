import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onReset;
  final bool isAutoMode;
  final VoidCallback onToggleAuto;

  const ControlPanel({
    super.key,
    required this.onStart,
    required this.onReset,
    required this.isAutoMode,
    required this.onToggleAuto,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: [
        ElevatedButton.icon(
          onPressed: onStart,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start'),
        ),
        ElevatedButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.refresh),
          label: const Text('Reset'),
        ),
        ElevatedButton.icon(
          onPressed: onToggleAuto,
          icon: Icon(isAutoMode ? Icons.pause_circle : Icons.autorenew),
          label: Text(isAutoMode ? 'Manual' : 'Auto'),
        ),
      ],
    );
  }
}
