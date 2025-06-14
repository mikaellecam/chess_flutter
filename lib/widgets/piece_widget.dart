import 'package:flutter/material.dart';

import '../models/piece.dart';

class ChessPieceWidget extends StatelessWidget {
  final Piece piece;
  final double size;

  const ChessPieceWidget({super.key, required this.piece, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      child: Text(
        _getPieceSymbol(),
        style: TextStyle(
          fontSize: size * 0.8,
          color: piece.color == PieceColor.white ? Colors.white : Colors.black,
          shadows:
              piece.color == PieceColor.white
                  ? [const Shadow(offset: Offset(1, 1), color: Colors.black54)]
                  : [const Shadow(offset: Offset(1, 1), color: Colors.white54)],
        ),
      ),
    );
  }

  String _getPieceSymbol() {
    switch (piece.type) {
      case PieceType.pawn:
        return piece.color == PieceColor.white ? '♙' : '♟';
      case PieceType.rook:
        return piece.color == PieceColor.white ? '♖' : '♜';
      case PieceType.knight:
        return piece.color == PieceColor.white ? '♘' : '♞';
      case PieceType.bishop:
        return piece.color == PieceColor.white ? '♗' : '♝';
      case PieceType.queen:
        return piece.color == PieceColor.white ? '♕' : '♛';
      case PieceType.king:
        return piece.color == PieceColor.white ? '♔' : '♚';
    }
  }
}
