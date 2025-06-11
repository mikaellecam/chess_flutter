import 'package:chess_flutter/models/board.dart';
import 'package:chess_flutter/models/position.dart';

import '../models/piece.dart';

class PieceMovement {
  static Set<Position> getValidMoves(Board board, Position position) {
    final piece = board.pieceAt(position);
    if (piece == null || piece.color != board.currentTurn) return {};

    switch (piece.type) {
      case PieceType.pawn:
        return _getPawnMoves(board, position, piece);
      case PieceType.rook:
        return _getRookMoves(board, position, piece);
      case PieceType.knight:
        return _getKnightMoves(board, position, piece);
      case PieceType.bishop:
        return _getBishopMoves(board, position, piece);
      case PieceType.queen:
        return _getQueenMoves(board, position, piece);
      case PieceType.king:
        return _getKingMoves(board, position, piece);
    }
  }

  static Set<Position> _getPawnMoves(
    Board board,
    Position position,
    Piece piece,
  ) {
    final moves = <Position>{};
    final direction = piece.color == PieceColor.white ? -1 : 1;

    // Forward move
    final oneForward = Position(position.row + direction, position.col);
    if (oneForward.isValid && board.pieceAt(oneForward) == null) {
      moves.add(oneForward);

      // Two squares forward from starting position
      if (!piece.hasMoved) {
        final twoForward = Position(position.row + 2 * direction, position.col);
        if (twoForward.isValid && board.pieceAt(twoForward) == null) {
          moves.add(twoForward);
        }
      }
    }

    // Diagonal captures
    for (final colOffset in [-1, 1]) {
      final capturePos = Position(
        position.row + direction,
        position.col + colOffset,
      );
      if (capturePos.isValid) {
        final targetPiece = board.pieceAt(capturePos);
        if (targetPiece != null && targetPiece.color != piece.color) {
          moves.add(capturePos);
        }
      }
    }

    return moves;
  }

  static Set<Position> _getRookMoves(
    Board board,
    Position position,
    Piece piece,
  ) {
    final moves = <Position>{};

    final directions = [
      Position(-1, 0),
      Position(1, 0),
      Position(0, -1),
      Position(0, 1),
    ];

    for (final direction in directions) {
      moves.addAll(
        _getAllMovesInDirection(board, position, direction, piece.color),
      );
    }

    return moves;
  }

  static Set<Position> _getKnightMoves(
    Board board,
    Position position,
    Piece piece,
  ) {
    final moves = <Position>{};

    final knightMoves = [
      Position(-2, -1),
      Position(-2, 1),
      Position(-1, -2),
      Position(-1, 2),
      Position(1, -2),
      Position(1, 2),
      Position(2, -1),
      Position(2, 1),
    ];

    for (final move in knightMoves) {
      final newPos = position + move;
      if (newPos.isValid) {
        final targetPiece = board.pieceAt(newPos);
        if (targetPiece == null || targetPiece.color != piece.color) {
          moves.add(newPos);
        }
      }
    }

    return moves;
  }

  static Set<Position> _getBishopMoves(
    Board board,
    Position position,
    Piece piece,
  ) {
    final moves = <Position>{};

    final directions = [
      Position(-1, -1),
      Position(-1, 1),
      Position(1, -1),
      Position(1, 1),
    ];

    for (final direction in directions) {
      moves.addAll(
        _getAllMovesInDirection(board, position, direction, piece.color),
      );
    }

    return moves;
  }

  static Set<Position> _getQueenMoves(
    Board board,
    Position position,
    Piece piece,
  ) {
    final moves = <Position>{};
    moves.addAll(_getRookMoves(board, position, piece));
    moves.addAll(_getBishopMoves(board, position, piece));
    return moves;
  }

  static Set<Position> _getKingMoves(
    Board board,
    Position position,
    Piece piece,
  ) {
    final moves = <Position>{};

    // All 8 directions, one square each
    for (int rowOffset = -1; rowOffset <= 1; rowOffset++) {
      for (int colOffset = -1; colOffset <= 1; colOffset++) {
        if (rowOffset == 0 && colOffset == 0) continue;

        final newPos = Position(
          position.row + rowOffset,
          position.col + colOffset,
        );
        if (newPos.isValid) {
          // TODO Add another check for the new position not checking the king
          final targetPiece = board.pieceAt(newPos);
          if (targetPiece == null || targetPiece.color != piece.color) {
            moves.add(newPos);
          }
        }
      }
    }

    return moves;
  }

  static Set<Position> _getAllMovesInDirection(
    Board board,
    Position start,
    Position direction,
    PieceColor pieceColor,
  ) {
    final moves = <Position>{};
    Position current = start + direction;

    while (current.isValid) {
      final piece = board.pieceAt(current);

      if (piece == null) {
        moves.add(current);
      } else if (piece.color != pieceColor) {
        moves.add(current); // Capture move
        break;
      } else {
        // Same color piece
        break;
      }

      current = current + direction;
    }

    return moves;
  }
}

extension on Position {
  operator +(Position other) => Position(row + other.row, col + other.col);
}
