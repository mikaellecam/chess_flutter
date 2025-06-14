import 'package:chess_flutter/models/board.dart';
import 'package:chess_flutter/models/position.dart';

import '../models/piece.dart';
import 'check_detection.dart';

class PieceMovement {
  static Set<Position> getValidMoves(Board board, Position position) {
    final piece = board.pieceAt(position);
    if (piece == null || piece.color != board.currentTurn) return {};

    Set<Position> possibleMoves;
    switch (piece.type) {
      case PieceType.pawn:
        possibleMoves = _getPawnMoves(board, position, piece);
        break;
      case PieceType.rook:
        possibleMoves = _getRookMoves(board, position, piece);
        break;
      case PieceType.knight:
        possibleMoves = _getKnightMoves(board, position, piece);
        break;
      case PieceType.bishop:
        possibleMoves = _getBishopMoves(board, position, piece);
        break;
      case PieceType.queen:
        possibleMoves = _getQueenMoves(board, position, piece);
        break;
      case PieceType.king:
        possibleMoves = _getKingMoves(board, position, piece);
        break;
    }
    return _filterMovesForCheck(board, position, possibleMoves);
  }

  static Set<Position> _filterMovesForCheck(
    Board board,
    Position fromPosition,
    Set<Position> possibleMoves,
  ) {
    final piece = board.pieceAt(fromPosition);
    if (piece == null) return {};

    final validMoves = <Position>{};

    for (final toPosition in possibleMoves) {
      final simulatedBoard = _simulateMove(board, fromPosition, toPosition);

      // Check if this move leaves our king in check
      if (!CheckDetection.isInCheck(simulatedBoard, piece.color)) {
        validMoves.add(toPosition);
      }
    }

    return validMoves;
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
          final targetPiece = board.pieceAt(newPos);
          if (targetPiece == null || targetPiece.color != piece.color) {
            moves.add(newPos);
          }
        }
      }
    }

    return moves;
  }

  static Board _simulateMove(Board board, Position from, Position to) {
    final piece = board.pieceAt(from);
    if (piece == null) return board;

    final newBoard = List.generate(8, (i) => List<Piece?>.from(board.board[i]));

    newBoard[to.row][to.col] = piece;
    newBoard[from.row][from.col] = null;

    return Board.simulate(
      board: newBoard,
      currentTurn: board.currentTurn,
      moveHistory: board.moveHistory,
    );
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
