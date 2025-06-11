import 'package:chess_flutter/widgets/square.dart';
import 'package:flutter/material.dart';

import '../models/board.dart';
import '../models/position.dart';

class BoardWidget extends StatelessWidget {
  final Board board;
  final Function(Position) onSquareTapped;
  final bool isFlipped;

  const BoardWidget({
    super.key,
    required this.board,
    required this.onSquareTapped,
    this.isFlipped = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.brown.shade600,
          borderRadius: BorderRadius.circular(8),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            childAspectRatio: 1.0,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          itemCount: 64,
          itemBuilder: (context, index) {
            final row = isFlipped ? 7 - (index ~/ 8) : index ~/ 8;
            final col = isFlipped ? 7 - (index % 8) : index % 8;
            final position = Position(row, col);

            return Square(
              piece: board.pieceAt(position),
              position: position,
              isSelected: board.selectedPosition == position,
              isValidMove: board.validMoves.contains(position),
              onTap: () => onSquareTapped(position),
            );
          },
        ),
      ),
    );
  }
}
