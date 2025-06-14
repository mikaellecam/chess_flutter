import 'package:flutter/material.dart' hide TimePickerDialog;

import '../utils/duration_formatter.dart';
import 'time_picker_dialog.dart';

class CustomTimeControls extends StatelessWidget {
  final Duration customTime;
  final Duration customIncrement;
  final ValueChanged<Duration> onTimeChanged;
  final ValueChanged<Duration> onIncrementChanged;

  const CustomTimeControls({
    super.key,
    required this.customTime,
    required this.customIncrement,
    required this.onTimeChanged,
    required this.onIncrementChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Custom Time Controls',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Time per player
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Time per player: ${DurationFormatter.format(customTime)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => _showTimePicker(context, true),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Increment
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Increment per move: ${DurationFormatter.format(customIncrement)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => _showTimePicker(context, false),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context, bool isMainTime) async {
    final Duration currentDuration = isMainTime ? customTime : customIncrement;

    final Duration? newDuration = await showDialog<Duration>(
      context: context,
      builder:
          (BuildContext context) => TimePickerDialog(
            title: isMainTime ? 'Set Time per Player' : 'Set Increment',
            initialDuration: currentDuration,
            isMainTime: isMainTime,
            initialTime: null,
          ),
    );

    if (newDuration != null) {
      if (isMainTime) {
        onTimeChanged(newDuration);
      } else {
        onIncrementChanged(newDuration);
      }
    }
  }
}
