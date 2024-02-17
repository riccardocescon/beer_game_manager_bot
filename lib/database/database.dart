import 'dart:io';
import 'package:beer_game_manager_bot/entities/game.dart';
import 'package:beer_game_manager_bot/utils/all_games.dart' as all_games;
import 'package:beer_game_manager_bot/utils/paths.dart' as path_utils;

class BeerDatabase {
  static final BeerDatabase instance = BeerDatabase._internal();
  BeerDatabase._internal();

  final _dbFile = File(path_utils.Paths.db);

  final dbVersion = 0;

  void setup({required int dbVersion}) {
    if (!_dbFile.existsSync()) {
      _dbFile.createSync();
    }
    final content = _dbFile.readAsStringSync();
    _setupGames(content);

    final beerGames = all_games.allBeerGames.toList();
    print('Loaded: ${beerGames.length} games');
  }

  void _setupGames(String content) {
    final lines = content.split('\n');
    final games = all_games.allGames.toList();
    bool mustSave = false;
    all_games.resetBeerGames();
    for (final game in games) {
      final exists = lines.any((element) => element.contains(game.name));
      late BeerGame beerGame;
      if (!exists) {
        final stats = GameStats(playCount: 0, lastPlayed: DateTime.now());
        beerGame = BeerGame.withStats(game: game, stats: stats);
        mustSave = true;
      } else {
        final gameData =
            lines.firstWhere((element) => element.contains(game.name));
        beerGame = BeerGame.fromFile(game: game, file: gameData);
      }

      all_games.addBeerGame(beerGame);
    }

    if (mustSave) {
      _saveGames(all_games.allBeerGames.toList());
    }
  }

  void _saveGames(List<BeerGame> games) {
    final lines = games.map((e) => e.toFile()).toList();
    final content = lines.join('\n');
    _dbFile.writeAsStringSync(content);
  }

  void updateGames(List<BeerGame> games) {
    final allGames = all_games.allBeerGames.toList();
    for (final game in games.toList()) {
      final has = allGames.any((element) => element.name == game.name);
      if (!has) {
        print('Game not found: ${game.name}, skipping...');
        continue;
      }

      final index = allGames.indexWhere((element) => element.name == game.name);
      allGames[index] = game;
    }

    _saveGames(allGames);
  }

  void deleteDB() {
    _dbFile.writeAsStringSync('');
    setup(dbVersion: dbVersion);
  }
}
