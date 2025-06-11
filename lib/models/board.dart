import 'package:chess_flutter/models/move.dart';
import 'package:chess_flutter/models/piece.dart';
import 'package:chess_flutter/models/position.dart';

import '../utils/piece_movement.dart';

class Board {
  final List<List<Piece?>> _board;
  final PieceColor currentTurn;
  final Position? selectedPosition;
  final Set<Position> validMoves;
  final List<Move> moveHistory;

  Board._({
    required List<List<Piece?>> board,
    required this.currentTurn,
    this.selectedPosition,
    required this.validMoves,
    required this.moveHistory,
  }) : _board = board;

  factory Board.initial() {
    final board = List.generate(8, (i) => List<Piece?>.filled(8, null));

    _setupInitialPosition(board);

    return Board._(
      board: board,
      currentTurn: PieceColor.white,
      validMoves: {},
      moveHistory: [],
    );
  }

  static void _setupInitialPosition(List<List<Piece?>> board) {
    // Black pieces (top of the board)
    board[0] = [
      const Piece(type: PieceType.rook, color: PieceColor.black),
      const Piece(type: PieceType.knight, color: PieceColor.black),
      const Piece(type: PieceType.bishop, color: PieceColor.black),
      const Piece(type: PieceType.queen, color: PieceColor.black),
      const Piece(type: PieceType.king, color: PieceColor.black),
      const Piece(type: PieceType.bishop, color: PieceColor.black),
      const Piece(type: PieceType.knight, color: PieceColor.black),
      const Piece(type: PieceType.rook, color: PieceColor.black),
    ];

    // Black pawns
    for (int i = 0; i < 8; i++) {
      board[1][i] = const Piece(type: PieceType.pawn, color: PieceColor.black);
    }

    // White pawns
    for (int i = 0; i < 8; i++) {
      board[6][i] = const Piece(type: PieceType.pawn, color: PieceColor.white);
    }

    // White pieces (bottom of the board)
    board[7] = [
      const Piece(type: PieceType.rook, color: PieceColor.white),
      const Piece(type: PieceType.knight, color: PieceColor.white),
      const Piece(type: PieceType.bishop, color: PieceColor.white),
      const Piece(type: PieceType.queen, color: PieceColor.white),
      const Piece(type: PieceType.king, color: PieceColor.white),
      const Piece(type: PieceType.bishop, color: PieceColor.white),
      const Piece(type: PieceType.knight, color: PieceColor.white),
      const Piece(type: PieceType.rook, color: PieceColor.white),
    ];
  }

  Piece? pieceAt(Position position) {
    if (!position.isValid) return null;
    return _board[position.row][position.col];
  }

  Board selectPosition(Position position) {
    final piece = pieceAt(position);

    if (piece == null || piece.color != currentTurn) {
      return _copyWith(selectedPosition: null, validMoves: {});
    }

    final moves = PieceMovement.getValidMoves(this, position);

    return _copyWith(selectedPosition: position, validMoves: moves);
  }

  Board makeMove(Position from, Position to) {
    final piece = pieceAt(from);
    if (piece == null) return this;

    final newBoard = List.generate(8, (i) => List<Piece?>.from(_board[i]));

    newBoard[to.row][to.col] = piece.copyWith(hasMoved: true);
    newBoard[from.row][from.col] = null;

    final move = Move(
      from: from,
      to: to,
      capturedPiece: _board[to.row][to.col],
      isCapture: _board[to.row][to.col] != null,
    );

    return Board._(
      board: newBoard,
      currentTurn:
          currentTurn == PieceColor.white ? PieceColor.black : PieceColor.white,
      selectedPosition: null,
      validMoves: {},
      moveHistory: [...moveHistory, move],
    );
  }

  Board _copyWith({
    List<List<Piece?>>? board,
    PieceColor? currentTurn,
    Position? selectedPosition,
    Set<Position>? validMoves,
    List<Move>? moveHistory,
  }) {
    return Board._(
      board: board ?? List.generate(8, (i) => List<Piece?>.from(_board[i])),
      currentTurn: currentTurn ?? this.currentTurn,
      selectedPosition: selectedPosition,
      validMoves: validMoves ?? Set<Position>.from(this.validMoves),
      moveHistory: moveHistory ?? List<Move>.from(this.moveHistory),
    );
  }
}
