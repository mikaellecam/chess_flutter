import 'package:flutter/material.dart';

import '../models/game_type.dart';
import '../utils/duration_formatter.dart';

class GameTypeSelector extends StatelessWidget {
  final GameType selectedGameType;
  final ValueChanged<GameType?> onGameTypeChanged;

  const GameTypeSelector({
    super.key,
    required this.selectedGameType,
    required this.onGameTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Game Type', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            ...GameType.values.map(
              (gameType) => RadioListTile<GameType>(
                title: Text(gameType.displayName),
                subtitle:
                    gameType != GameType.custom
                        ? Text(
                          DurationFormatter.formatTimeControl(
                            gameType.defaultTime,
                            gameType.defaultIncrement,
                          ),
                        )
                        : const Text('Configure your own time'),
                value: gameType,
                groupValue: selectedGameType,
                onChanged: onGameTypeChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
