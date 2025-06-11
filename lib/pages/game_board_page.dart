import 'package:flutter/material.dart';

import '../models/board.dart';
import '../models/game_config.dart';
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

  @override
  void initState() {
    super.initState();
    _board = Board.initial();
    _player1Time = widget.config.timePerPlayer;
    _player2Time = widget.config.timePerPlayer;
  }

  void _onSquareTapped(Position position) {
    setState(() {
      if (_board.selectedPosition != null &&
          _board.validMoves.contains(position)) {
        _board = _board.makeMove(_board.selectedPosition!, position);
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
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() {
                _board = Board.initial();
                _player1Time = widget.config.timePerPlayer;
                _player2Time = widget.config.timePerPlayer;
              });
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Player 2 (Black) info - close to top of board
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

          // Chess board - takes up remaining space
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BoardWidget(
              board: _board,
              onSquareTapped: _onSquareTapped,
              isFlipped: false, // TODO: Make this configurable
            ),
          ),

          // Player 1 (White) info - close to bottom of board
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

          // Game controls at the bottom
          // TODO : Add more controls like undo, redo, and pause/play the timers
          /*Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

              ],
            ),
          ),*/
        ],
      ),
    );
  }
}
