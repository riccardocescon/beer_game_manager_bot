import 'package:beer_game_manager_bot/entities/game.dart';

final _beerGames = <BeerGame>[];
void addBeerGame(BeerGame game) => _beerGames.add(game);
void resetBeerGames() => _beerGames.clear();

List<BeerGame> get allBeerGames => _beerGames.toList();

List<Game> get allGames => [
      Game(name: 'Unicorn Fever', minPlayers: 2, maxPlayers: 6),
      Game(name: 'Exploding kittens', minPlayers: 2, maxPlayers: 5),
      Game(name: 'Shamans', minPlayers: 3, maxPlayers: 5),
      Game(name: 'Cobble & fog', minPlayers: 2, maxPlayers: 4),
      Game(name: 'Carcassonne', minPlayers: 2, maxPlayers: 6),
      Game(name: 'Risiko', minPlayers: 3, maxPlayers: 6),
      Game(
        name: 'War chest',
        minPlayers: 2,
        maxPlayers: 4,
        onlyMinMaxPlayers: true,
      ),
      Game(name: 'Attack on titan', minPlayers: 2, maxPlayers: 5),
      Game(name: 'Terra Mystica', minPlayers: 2, maxPlayers: 5),
      Game(name: 'Illuminati', minPlayers: 2, maxPlayers: 6),
      Game(name: 'Oltre', minPlayers: 2, maxPlayers: 4),
      Game(name: 'Throw throw burrito', minPlayers: 2, maxPlayers: 6),
      Game(name: 'Iwari', minPlayers: 2, maxPlayers: 5),
      Game(name: 'Attack on titan deck Building', minPlayers: 1, maxPlayers: 5),
      Game(name: 'Munchkin', minPlayers: 3, maxPlayers: 6),
      Game(name: 'Top ten', minPlayers: 4, maxPlayers: 9),
      Game(name: 'Here to slay', minPlayers: 2, maxPlayers: 6),
      Game(name: 'CCT express', minPlayers: 2, maxPlayers: 6),
      Game(name: 'Feed the Kraken', minPlayers: 5, maxPlayers: 11),
      Game(name: 'Unearth', minPlayers: 2, maxPlayers: 4),
      Game(name: 'Bang', minPlayers: 3, maxPlayers: 8),
      Game(name: 'Rising sun', minPlayers: 3, maxPlayers: 5),
      Game(name: 'Abalone', minPlayers: 2, maxPlayers: 2),
    ];

List<BeerGame> gamesForPlayers(int players) {
  final games = allBeerGames.toList();

  // Remove games that are not suitable for the number of players
  games.removeWhere((element) =>
      players < element.minPlayers || players > element.maxPlayers);

  // Remove games that are only suitable for a specific number of players and
  // the number of players is not the one
  games.removeWhere(
    (element) =>
        element.onlyMinMaxPlayers &&
        players != element.minPlayers &&
        players != element.maxPlayers,
  );

  return games;
}
