import 'package:beer_game_manager_bot/entities/game.dart';
import 'package:beer_game_manager_bot/utils/all_games.dart';
import 'package:test/test.dart';

void main() {
  group('gamesForPlayers', () {
    test('1 Player', () {
      final games = gamesForPlayers(1);
      final expectedResult = [
        Game(
            name: 'Attack on titan deck Building',
            minPlayers: 1,
            maxPlayers: 5),
      ];

      expect(games, expectedResult);
    });
    test('13 Player', () {
      final games = gamesForPlayers(13);
      final expectedResult = [];

      expect(games, expectedResult);
    });
    test('3 Player', () {
      final games = gamesForPlayers(3);
      final expectedResult = [
        Game(name: 'Unicorn Fever', minPlayers: 2, maxPlayers: 6),
        Game(name: 'Exploding kittens', minPlayers: 2, maxPlayers: 5),
        Game(name: 'Shamans', minPlayers: 3, maxPlayers: 5),
        Game(name: 'Cobble & fog', minPlayers: 2, maxPlayers: 4),
        Game(name: 'Carcassonne', minPlayers: 2, maxPlayers: 6),
        Game(name: 'Risiko', minPlayers: 3, maxPlayers: 6),
        Game(name: 'Attack on titan', minPlayers: 2, maxPlayers: 5),
        Game(name: 'Terra Mystica', minPlayers: 2, maxPlayers: 5),
        Game(name: 'Illuminati', minPlayers: 2, maxPlayers: 6),
        Game(name: 'Oltre', minPlayers: 2, maxPlayers: 4),
        Game(name: 'Throw throw burrito', minPlayers: 2, maxPlayers: 6),
        Game(name: 'Iwari', minPlayers: 2, maxPlayers: 5),
        Game(
          name: 'Attack on titan deck Building',
          minPlayers: 1,
          maxPlayers: 5,
        ),
        Game(name: 'Munchkin', minPlayers: 3, maxPlayers: 6),
        Game(name: 'Here to slay', minPlayers: 2, maxPlayers: 6),
        Game(name: 'CCT express', minPlayers: 2, maxPlayers: 6),
        Game(name: 'Unearth', minPlayers: 2, maxPlayers: 4),
        Game(name: 'Bang', minPlayers: 3, maxPlayers: 8),
        Game(name: 'Rising sun', minPlayers: 3, maxPlayers: 5),
      ];

      expect(games, expectedResult);
    });
  });
}
