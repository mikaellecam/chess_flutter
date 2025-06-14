import 'package:chess_flutter/models/piece.dart';
import 'package:chess_flutter/models/position.dart';

import '../utils/check_detection.dart';
import '../utils/piece_movement.dart';
import 'board.dart';

enum GameState { playing, check, checkmate, stalemate, draw }

class GameStateDetection {
  static GameState getGameState(Board board) {
    final currentPlayer = board.currentTurn;
    final isInCheck = CheckDetection.isInCheck(board, currentPlayer);
    final hasValidMoves = _hasAnyValidMoves(board, currentPlayer);

    if (isInCheck && !hasValidMoves) {
      return GameState.checkmate;
    } else if (!isInCheck && !hasValidMoves) {
      return GameState.stalemate;
    } else if (isInCheck) {
      return GameState.check;
    } else {
      return GameState.playing;
    }
  }

  static bool _hasAnyValidMoves(Board board, PieceColor color) {
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        final position = Position(row, col);
        final piece = board.pieceAt(position);

        if (piece != null && piece.color == color) {
          final validMoves = PieceMovement.getValidMoves(board, position);
          if (validMoves.isNotEmpty) {
            return true;
          }
        }
      }
    }
    return false;
  }

  static String getGameEndMessage(
    GameState state,
    PieceColor currentPlayer,
    String player1Name,
    String player2Name,
  ) {
    switch (state) {
      case GameState.checkmate:
        final winner =
            currentPlayer == PieceColor.white
                ? '$player2Name (Black)'
                : '$player1Name (White)';
        return '$winner wins by checkmate!';
      case GameState.stalemate:
        final currentPlayerName =
            currentPlayer == PieceColor.white ? player1Name : player2Name;
        return 'Draw by stalemate!\n$currentPlayerName has no legal moves but is not in check.';
      case GameState.draw:
        return 'Draw!';
      default:
        return '';
    }
  }

  static String getGameEndTitle(GameState state) {
    switch (state) {
      case GameState.checkmate:
        return 'Checkmate!';
      case GameState.stalemate:
        return 'Stalemate!';
      case GameState.draw:
        return 'Draw!';
      default:
        return 'Game Over';
    }
  }
}
