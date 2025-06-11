import 'package:chess_flutter/models/game_type.dart';
import 'package:flutter/material.dart';

import '../models/game_config.dart';
import '../utils/duration_formatter.dart';

class GameBoardPage extends StatelessWidget {
  final GameConfig config;

  const GameBoardPage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${config.player1Name} vs ${config.player2Name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Game Board - Coming Next!'),
            Text('Game Type: ${config.gameType.displayName}'),
            Text('Time: ${DurationFormatter.format(config.timePerPlayer)}'),
            Text('Increment: ${DurationFormatter.format(config.increment)}'),
          ],
        ),
      ),
    );
  }
}
