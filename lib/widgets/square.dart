import 'package:flutter/material.dart';

import '../models/piece.dart';
import '../models/position.dart';
import 'piece_widget.dart';

class Square extends StatelessWidget {
  final Piece? piece;
  final Position position;
  final bool isSelected;
  final bool isValidMove;
  final VoidCallback onTap;

  const Square({
    super.key,
    this.piece,
    required this.position,
    required this.isSelected,
    required this.isValidMove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLightSquare = (position.row + position.col) % 2 == 0;

    Color backgroundColor;
    if (isSelected) {
      backgroundColor = Colors.yellow.shade300;
    } else if (isValidMove) {
      backgroundColor =
          piece != null
              ? Colors
                  .red
                  .shade300 // Capture move
              : Colors.green.shade300; // Normal move
    } else {
      backgroundColor =
          isLightSquare ? Colors.brown.shade100 : Colors.brown.shade400;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.brown.shade600, width: 0.5),
        ),
        child: Stack(
          children: [
            if (position.col == 0)
              Positioned(
                left: 2,
                top: 2,
                child: Text(
                  (8 - position.row).toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        isLightSquare
                            ? Colors.brown.shade700
                            : Colors.brown.shade200,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (position.row == 7)
              Positioned(
                right: 2,
                bottom: 2,
                child: Text(
                  String.fromCharCode('a'.codeUnitAt(0) + position.col),
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        isLightSquare
                            ? Colors.brown.shade700
                            : Colors.brown.shade200,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            if (piece != null) Center(child: ChessPieceWidget(piece: piece!)),

            if (isValidMove && piece == null)
              Center(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
