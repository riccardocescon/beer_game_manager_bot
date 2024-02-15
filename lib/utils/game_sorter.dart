import 'package:beer_game_manager_bot/entities/game.dart';

List<BeerGame> sortGamesByPlayCount(List<BeerGame> games, bool olderFirst) {
  // sort the given list first based on the play count, then based on the last played date
  games.sort((a, b) {
    if (a.stats.playCount == b.stats.playCount) {
      if (olderFirst) {
        return a.stats.lastPlayed.compareTo(b.stats.lastPlayed);
      } else {
        return b.stats.lastPlayed.compareTo(a.stats.lastPlayed);
      }
    } else {
      return a.stats.playCount.compareTo(b.stats.playCount);
    }
  });

  return games;
}
