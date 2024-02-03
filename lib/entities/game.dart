import 'package:equatable/equatable.dart';

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
