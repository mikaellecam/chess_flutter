import 'dart:async';

import 'package:flutter/material.dart';

import '../models/board.dart';
import '../models/game_config.dart';
import '../models/game_state.dart';
import '../models/piece.dart';
import '../models/position.dart';
import '../widgets/board_widget.dart';
import '../widgets/game_info_panel.dart';

class GameBoardPage extends StatefulWidget {
  final GameConfig config;

  const GameBoardPage({super.key, required this.config});

  @override
  State<GameBoardPage> createState() => _GameBoardPageState();
}

class _GameBoardPageState extends State<GameBoardPage> {
  late Board _board;
  late Duration _player1Time;
  late Duration _player2Time;
  Timer? _gameTimer;
  bool _isGamePaused = false;
  bool _isGameOver = false;
  bool _hasGameStarted = false;

  @override
  void initState() {
    super.initState();
    _board = Board.initial();
    _player1Time = widget.config.timePerPlayer;
    _player2Time = widget.config.timePerPlayer;
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _checkGameState() {
    final gameState = GameStateDetection.getGameState(_board);

    if (gameState == GameState.checkmate || gameState == GameState.stalemate) {
      _isGameOver = true;
      _gameTimer?.cancel();

      final title = GameStateDetection.getGameEndTitle(gameState);
      final message = GameStateDetection.getGameEndMessage(
        gameState,
        _board.currentTurn,
        widget.config.player1Name,
        widget.config.player2Name,
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        _showGameEndDialog(title, message);
      });
    }
  }

  void _addIncrementTime(PieceColor playerWhoJustMoved) {
    final incrementSeconds = widget.config.increment.inSeconds;

    if (incrementSeconds > 0) {
      if (playerWhoJustMoved == PieceColor.white) {
        _player1Time = Duration(
          seconds: _player1Time.inSeconds + incrementSeconds,
        );
      } else {
        _player2Time = Duration(
          seconds: _player2Time.inSeconds + incrementSeconds,
        );
      }
    }
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isGameOver && mounted) {
        setState(() {
          if (_hasGameStarted && !_isGamePaused) {
            if (_board.currentTurn == PieceColor.white) {
              if (_player1Time.inSeconds > 0) {
                _player1Time = Duration(seconds: _player1Time.inSeconds - 1);
              } else {
                _handleTimeOut(PieceColor.white);
                return;
              }
            } else {
              if (_player2Time.inSeconds > 0) {
                _player2Time = Duration(seconds: _player2Time.inSeconds - 1);
              } else {
                _handleTimeOut(PieceColor.black);
                return;
              }
            }
          }
        });
      }
    });
  }

  void _handleTimeOut(PieceColor player) {
    _isGameOver = true;
    _gameTimer?.cancel();

    final winner =
        player == PieceColor.white
            ? widget.config.player2Name
            : widget.config.player1Name;

    _showGameEndDialog('Time Out!', '$winner wins by timeout!');
  }

  void _showGameEndDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text('New Game'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  void _pauseResumeGame() {
    setState(() {
      _isGamePaused = !_isGamePaused;
    });
  }

  void _resetGame() {
    setState(() {
      _board = Board.initial();
      _player1Time = widget.config.timePerPlayer;
      _player2Time = widget.config.timePerPlayer;
      _isGamePaused = false;
      _isGameOver = false;
      _hasGameStarted = false;
    });
    _gameTimer?.cancel();
  }

  void _onSquareTapped(Position position) {
    if (_isGamePaused || _isGameOver) return;

    setState(() {
      if (_board.selectedPosition != null &&
          _board.validMoves.contains(position)) {
        final previousTurn = _board.currentTurn;
        _board = _board.makeMove(_board.selectedPosition!, position);

        if (!_hasGameStarted) {
          _hasGameStarted = true;
          _startTimer();
          return;
        }

        _addIncrementTime(previousTurn);

        _checkGameState();
      } else {
        _board = _board.selectPosition(position);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.config.player1Name} vs ${widget.config.player2Name}',
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              _isGamePaused ? Icons.play_arrow : Icons.pause,
              color: Colors.black,
            ),
            onPressed: _isGameOver ? null : _pauseResumeGame,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: GameInfoPanel(
              board: _board,
              playerName: widget.config.player2Name,
              timeRemaining: _player2Time,
              isCurrentTurn: _board.currentTurn == PieceColor.black,
              playerColor: PieceColor.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BoardWidget(
              board: _board,
              onSquareTapped: _onSquareTapped,
              isFlipped: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: GameInfoPanel(
              board: _board,
              playerName: widget.config.player1Name,
              timeRemaining: _player1Time,
              isCurrentTurn: _board.currentTurn == PieceColor.white,
              playerColor: PieceColor.white,
            ),
          ),
          if (_isGamePaused)
            Container(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.pause_circle_outline, size: 32),
                      const SizedBox(width: 8),
                      Text(
                        'Game Paused',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
