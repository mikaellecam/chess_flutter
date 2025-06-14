enum GameType { bullet, blitz, rapid, classical, custom }

extension GameTypeExtension on GameType {
  String get displayName {
    switch (this) {
      case GameType.bullet:
        return 'Bullet';
      case GameType.blitz:
        return 'Blitz';
      case GameType.rapid:
        return 'Rapid';
      case GameType.classical:
        return 'Classical';
      case GameType.custom:
        return 'Custom';
    }
  }

  Duration get defaultTime {
    switch (this) {
      case GameType.bullet:
        return const Duration(minutes: 1);
      case GameType.blitz:
        return const Duration(minutes: 5);
      case GameType.rapid:
        return const Duration(minutes: 15);
      case GameType.classical:
        return const Duration(minutes: 30);
      case GameType.custom:
        return const Duration(minutes: 5);
    }
  }

  Duration get defaultIncrement {
    switch (this) {
      case GameType.bullet:
        return const Duration(seconds: 1);
      case GameType.blitz:
        return const Duration(seconds: 3);
      case GameType.rapid:
        return const Duration(seconds: 10);
      case GameType.classical:
        return const Duration(seconds: 30);
      case GameType.custom:
        return Duration.zero;
    }
  }
}
