import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Game with EquatableMixin {
  final String name;
  final int minPlayers;
  final int maxPlayers;
  final bool onlyMinMaxPlayers;

  Game({
    required this.name,
    required this.minPlayers,
    required this.maxPlayers,
    this.onlyMinMaxPlayers = false,
  });

  @override
  List<Object?> get props => [name, minPlayers, maxPlayers, onlyMinMaxPlayers];
}

class BeerGame extends Game {
  GameStats stats;

  String get log {
    return '$name\nPC: ${stats.playCount},   LP: ${stats.playCount == 0 ? 'Never' : DateFormat('dd/MM/yyyy').format(stats.lastPlayed)}';
  }

  BeerGame({
    required super.name,
    required super.minPlayers,
    required super.maxPlayers,
    required this.stats,
    required super.onlyMinMaxPlayers,
  });

  factory BeerGame.withStats({required Game game, required GameStats stats}) {
    return BeerGame(
      name: game.name,
      minPlayers: game.minPlayers,
      maxPlayers: game.maxPlayers,
      onlyMinMaxPlayers: game.onlyMinMaxPlayers,
      stats: stats,
    );
  }

  factory BeerGame.fromFile({required String file, required Game game}) {
    final parts = file.split(',');
    parts.removeAt(0);
    return BeerGame(
      name: game.name,
      minPlayers: game.minPlayers,
      maxPlayers: game.maxPlayers,
      onlyMinMaxPlayers: game.onlyMinMaxPlayers,
      stats: GameStats.fromFile(parts.join(',')),
    );
  }

  String toFile() => '$name,${stats.toFile()}';
}

class GameStats {
  int playCount;
  DateTime lastPlayed;

  GameStats({
    required this.playCount,
    required this.lastPlayed,
  });

  factory GameStats.fromFile(String file) {
    final parts = file.split(',');
    return GameStats(
      playCount: int.parse(parts[0]),
      lastPlayed: DateTime.parse(parts[1]),
    );
  }

  String toFile() => '$playCount,${lastPlayed.toIso8601String()}';
}
