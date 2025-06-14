import 'game_type.dart';

class GameConfig {
  final String player1Name;
  final String player2Name;
  final GameType gameType;
  final Duration timePerPlayer;
  final Duration increment;

  const GameConfig({
    required this.player1Name,
    required this.player2Name,
    required this.gameType,
    required this.timePerPlayer,
    required this.increment,
  });
}
