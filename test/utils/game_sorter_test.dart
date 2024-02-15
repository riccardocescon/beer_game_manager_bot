import 'package:beer_game_manager_bot/entities/game.dart';
import 'package:beer_game_manager_bot/utils/game_sorter.dart';
import 'package:test/test.dart';

void main() {
  group('Play Count', () {
    test('Different play count', () {
      BeerGame game1 = BeerGame(
        name: '',
        maxPlayers: 0,
        minPlayers: 0,
        stats: GameStats(playCount: 1, lastPlayed: DateTime.now()),
        onlyMinMaxPlayers: false,
      );

      BeerGame game2 = BeerGame(
        name: '',
        maxPlayers: 0,
        minPlayers: 0,
        stats: GameStats(playCount: 2, lastPlayed: DateTime.now()),
        onlyMinMaxPlayers: false,
      );

      BeerGame game3 = BeerGame(
        name: '',
        maxPlayers: 0,
        minPlayers: 0,
        stats: GameStats(playCount: 3, lastPlayed: DateTime.now()),
        onlyMinMaxPlayers: false,
      );

      List<BeerGame> games = [game2, game1, game3];
      List<BeerGame> sortedGames = sortGamesByPlayCount(games, true);
      final expected = [game1, game2, game3];

      for (int i = 0; i < games.length; i++) {
        expect(sortedGames[i], expected[i]);
      }
    });

    test('Same play count Different Date', () {
      BeerGame game1 = BeerGame(
        name: '',
        maxPlayers: 0,
        minPlayers: 0,
        stats: GameStats(
          playCount: 2,
          lastPlayed: DateTime.now().subtract(Duration(days: 1)),
        ),
        onlyMinMaxPlayers: false,
      );

      BeerGame game2 = BeerGame(
        name: '',
        maxPlayers: 0,
        minPlayers: 0,
        stats: GameStats(playCount: 2, lastPlayed: DateTime.now()),
        onlyMinMaxPlayers: false,
      );

      BeerGame game3 = BeerGame(
        name: '',
        maxPlayers: 0,
        minPlayers: 0,
        stats: GameStats(playCount: 3, lastPlayed: DateTime.now()),
        onlyMinMaxPlayers: false,
      );

      List<BeerGame> games = [game2, game1, game3];
      List<BeerGame> sortedGames = sortGamesByPlayCount(games, true);
      final expected = [game1, game2, game3];

      for (int i = 0; i < games.length; i++) {
        expect(sortedGames[i], expected[i]);
      }
    });
  });
}
