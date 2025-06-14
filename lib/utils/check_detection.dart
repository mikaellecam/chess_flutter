import '../models/board.dart';
import '../models/piece.dart';
import '../models/position.dart';

class CheckDetection {
  static bool isInCheck(Board board, PieceColor kingColor) {
    final kingPosition = _findKing(board, kingColor);
    if (kingPosition == null) return false;

    return _isPositionUnderAttack(board, kingPosition, kingColor);
  }

  static Position? _findKing(Board board, PieceColor color) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final position = Position(row, col);
        final piece = board.pieceAt(position);
        if (piece != null &&
            piece.type == PieceType.king &&
            piece.color == color) {
          return position;
        }
      }
    }
    return null;
  }

  static bool isPositionUnderAttack(
    Board board,
    Position position,
    PieceColor defendingColor,
  ) {
    return _isPositionUnderAttack(board, position, defendingColor);
  }

  static bool _isPositionUnderAttack(
    Board board,
    Position position,
    PieceColor defendingColor,
  ) {
    final attackingColor =
        defendingColor == PieceColor.white
            ? PieceColor.black
            : PieceColor.white;

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piecePosition = Position(row, col);
        final piece = board.pieceAt(piecePosition);

        if (piece != null && piece.color == attackingColor) {
          if (_canPieceAttackPosition(board, piecePosition, piece, position)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  static bool _canPieceAttackPosition(
    Board board,
    Position piecePosition,
    Piece piece,
    Position targetPosition,
  ) {
    switch (piece.type) {
      case PieceType.pawn:
        return _canPawnAttack(piecePosition, piece, targetPosition);
      case PieceType.rook:
        return _canRookAttack(board, piecePosition, targetPosition);
      case PieceType.knight:
        return _canKnightAttack(piecePosition, targetPosition);
      case PieceType.bishop:
        return _canBishopAttack(board, piecePosition, targetPosition);
      case PieceType.queen:
        return _canQueenAttack(board, piecePosition, targetPosition);
      case PieceType.king:
        return _canKingAttack(piecePosition, targetPosition);
    }
  }

  static bool _canPawnAttack(Position pawnPos, Piece pawn, Position target) {
    final direction = pawn.color == PieceColor.white ? -1 : 1;
    final expectedRow = pawnPos.row + direction;

    return target.row == expectedRow &&
        (target.col == pawnPos.col - 1 || target.col == pawnPos.col + 1);
  }

  static bool _canRookAttack(Board board, Position rookPos, Position target) {
    if (rookPos.row != target.row && rookPos.col != target.col) return false;

    return _isPathClear(board, rookPos, target);
  }

  static bool _canKnightAttack(Position knightPos, Position target) {
    final rowDiff = (target.row - knightPos.row).abs();
    final colDiff = (target.col - knightPos.col).abs();

    return (rowDiff == 2 && colDiff == 1) || (rowDiff == 1 && colDiff == 2);
  }

  static bool _canBishopAttack(
    Board board,
    Position bishopPos,
    Position target,
  ) {
    final rowDiff = (target.row - bishopPos.row).abs();
    final colDiff = (target.col - bishopPos.col).abs();

    if (rowDiff != colDiff) return false;

    return _isPathClear(board, bishopPos, target);
  }

  static bool _canQueenAttack(Board board, Position queenPos, Position target) {
    return _canRookAttack(board, queenPos, target) ||
        _canBishopAttack(board, queenPos, target);
  }

  static bool _canKingAttack(Position kingPos, Position target) {
    final rowDiff = (target.row - kingPos.row).abs();
    final colDiff = (target.col - kingPos.col).abs();

    return rowDiff <= 1 && colDiff <= 1 && (rowDiff != 0 || colDiff != 0);
  }

  static bool _isPathClear(Board board, Position from, Position to) {
    if (from == to) return true;

    final rowDirection = (to.row - from.row).sign;
    final colDirection = (to.col - from.col).sign;

    Position current = Position(
      from.row + rowDirection,
      from.col + colDirection,
    );

    while (current != to) {
      if (board.pieceAt(current) != null) return false;
      current = Position(
        current.row + rowDirection,
        current.col + colDirection,
      );
    }

    return true;
  }

  static Set<Position> getAttackingPositions(
    Board board,
    PieceColor kingColor,
  ) {
    final kingPosition = _findKing(board, kingColor);
    if (kingPosition == null) return {};

    final attackingPositions = <Position>{};
    final attackingColor =
        kingColor == PieceColor.white ? PieceColor.black : PieceColor.white;

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final piecePosition = Position(row, col);
        final piece = board.pieceAt(piecePosition);

        if (piece != null &&
            piece.color == attackingColor &&
            _canPieceAttackPosition(
              board,
              piecePosition,
              piece,
              kingPosition,
            )) {
          attackingPositions.add(piecePosition);
        }
      }
    }

    return attackingPositions;
  }
}
