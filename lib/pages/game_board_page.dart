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
      // If we have a selected piece and this is a valid move
      if (_board.selectedPosition != null &&
          _board.validMoves.contains(position)) {
        _board = _board.makeMove(_board.selectedPosition!, position);
      } else {
        // Select the piece at this position
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Add game menu (resign, draw, etc.)
            },
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Column(
        children: [
          // Player 2 (Black) info - at top
          GameInfoPanel(
            board: _board,
            playerName: widget.config.player2Name,
            timeRemaining: _player2Time,
            isCurrentTurn: _board.currentTurn == PieceColor.black,
            playerColor: PieceColor.black,
          ),

          // Chess board
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BoardWidget(
                  board: _board,
                  onSquareTapped: _onSquareTapped,
                  isFlipped: false, // TODO: Make this configurable
                ),
              ),
            ),
          ),

          // Player 1 (White) info - at bottom
          GameInfoPanel(
            board: _board,
            playerName: widget.config.player1Name,
            timeRemaining: _player1Time,
            isCurrentTurn: _board.currentTurn == PieceColor.white,
            playerColor: PieceColor.white,
          ),

          // Move history or game controls
          Container(
            height: 60,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement resign
                  },
                  icon: const Icon(Icons.flag),
                  label: const Text('Resign'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement draw offer
                  },
                  icon: const Icon(Icons.handshake),
                  label: const Text('Draw'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _board = Board.initial();
                      _player1Time = widget.config.timePerPlayer;
                      _player2Time = widget.config.timePerPlayer;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Game'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
