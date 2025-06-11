import 'package:flutter/material.dart';

import '../models/game_config.dart';
import '../models/game_type.dart';
import '../widgets/custom_time_controls.dart';
import '../widgets/game_type_selector.dart';
import '../widgets/player_input_card.dart';
import '../widgets/welcome_card.dart';
import 'game_board_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();

  GameType _selectedGameType = GameType.blitz;
  Duration _customTime = const Duration(minutes: 10);
  Duration _customIncrement = Duration.zero;

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
  }

  void _startGame() {
    if (_formKey.currentState!.validate()) {
      final config = GameConfig(
        player1Name: _player1Controller.text.trim(),
        player2Name: _player2Controller.text.trim(),
        gameType: _selectedGameType,
        timePerPlayer:
            _selectedGameType == GameType.custom
                ? _customTime
                : _selectedGameType.defaultTime,
        increment:
            _selectedGameType == GameType.custom
                ? _customIncrement
                : _selectedGameType.defaultIncrement,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameBoardPage(config: config)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Game'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              const WelcomeCard(),

              const SizedBox(height: 24),

              PlayerInputCard(
                player1Controller: _player1Controller,
                player2Controller: _player2Controller,
              ),

              const SizedBox(height: 16),

              GameTypeSelector(
                selectedGameType: _selectedGameType,
                onGameTypeChanged: (GameType? value) {
                  setState(() {
                    _selectedGameType = value!;
                  });
                },
              ),

              if (_selectedGameType == GameType.custom) ...[
                const SizedBox(height: 16),
                CustomTimeControls(
                  customTime: _customTime,
                  customIncrement: _customIncrement,
                  onTimeChanged: (Duration newTime) {
                    setState(() {
                      _customTime = newTime;
                    });
                  },
                  onIncrementChanged: (Duration newIncrement) {
                    setState(() {
                      _customIncrement = newIncrement;
                    });
                  },
                ),
              ],

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _startGame,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Start Game', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
