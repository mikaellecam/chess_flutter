import 'package:flutter/material.dart';

class TimePickerDialog extends StatefulWidget {
  final String title;
  final Duration initialDuration;
  final bool isMainTime;

  const TimePickerDialog({
    super.key,
    required this.title,
    required this.initialDuration,
    required this.isMainTime,
    required initialTime,
  });

  @override
  State<TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  late int minutes;
  late int seconds;

  @override
  void initState() {
    super.initState();
    minutes = widget.initialDuration.inMinutes;
    seconds = widget.initialDuration.inSeconds % 60;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('Minutes'),
                    Slider(
                      value: minutes.toDouble(),
                      min: 0,
                      max: widget.isMainTime ? 60 : 5,
                      divisions: widget.isMainTime ? 60 : 5,
                      label: minutes.toString(),
                      onChanged: (value) {
                        setState(() {
                          minutes = value.round();
                        });
                      },
                    ),
                    Text(minutes.toString()),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    const Text('Seconds'),
                    Slider(
                      value: seconds.toDouble(),
                      min: 0,
                      max: 59,
                      divisions: 59,
                      label: seconds.toString(),
                      onChanged: (value) {
                        setState(() {
                          seconds = value.round();
                        });
                      },
                    ),
                    Text(seconds.toString()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final newDuration = Duration(minutes: minutes, seconds: seconds);
            Navigator.of(context).pop(newDuration);
          },
          child: const Text('Set'),
        ),
      ],
    );
  }
}
