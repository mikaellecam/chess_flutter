import 'package:chess_flutter/models/position.dart';

import 'piece.dart';

class Move {
  final Position from;
  final Position to;
  final Piece? capturedPiece;
  final bool isCapture;
  final bool isCheck;
  final bool isCheckmate;

  const Move({
    required this.from,
    required this.to,
    this.capturedPiece,
    this.isCapture = false,
    this.isCheck = false,
    this.isCheckmate = false,
  });

  @override
  String toString() {
    return '${from.algebraicNotation} -> ${to.algebraicNotation}';
  }
}
