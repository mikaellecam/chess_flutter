import 'package:flutter/material.dart';

import '../models/board.dart';
import '../models/piece.dart';
import '../utils/duration_formatter.dart';

class GameInfoPanel extends StatelessWidget {
  final Board board;
  final String playerName;
  final Duration timeRemaining;
  final bool isCurrentTurn;
  final PieceColor playerColor;

  const GameInfoPanel({
    super.key,
    required this.board,
    required this.playerName,
    required this.timeRemaining,
    required this.isCurrentTurn,
    required this.playerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrentTurn ? Colors.green.shade100 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentTurn ? Colors.green : Colors.grey,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color:
                  playerColor == PieceColor.white ? Colors.white : Colors.black,
              border: Border.all(color: Colors.grey),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              playerName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: isCurrentTurn ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:
                  timeRemaining.inSeconds < 60
                      ? Colors.red.shade100
                      : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              DurationFormatter.format(timeRemaining),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: timeRemaining.inSeconds < 60 ? Colors.red : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
