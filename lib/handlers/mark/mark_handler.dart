part of '../../beer_game_manager_bot.dart';

bool _markModeEnabled = false;
TeleDartMessage? _markRequestMessage;
Map<Game, bool> _markedGames = {};
void _markHandler(TeleDart teledart, TeleDartMessage message) async {
  final allGames = games_util.allGames.toList();

  _markedGames.clear();
  _markedGames.addEntries(allGames.map((e) => MapEntry(e, false)).toList());

  final groupedGames = <List<Game>>[];
  for (int i = 0; i < allGames.length; i += 2) {
    final games = <Game>[];
    if (i + 1 < allGames.length) {
      games.addAll([allGames[i], allGames[i + 1]]);
    } else {
      games.addAll([allGames[i]]);
    }

    groupedGames.add(games);
  }

  _markModeEnabled = true;

  _markRequestMessage = message;

  message.reply(
    'Which games do you want to mark this time?',
    replyMarkup: InlineKeyboardMarkup(
      inlineKeyboard: [
        ...groupedGames
            .map(
              (e) => e
                  .map(
                    (e) => InlineKeyboardButton(
                      text: e.name,
                      callbackData: e.name,
                    ),
                  )
                  .toList(),
            )
            .toList(),
        [
          InlineKeyboardButton(
            text: MarkCommands.cancel.value,
            callbackData: MarkCommands.cancel.value,
          ),
          InlineKeyboardButton(
            text: MarkCommands.confirm.value,
            callbackData: MarkCommands.confirm.value,
          ),
        ]
      ],
    ),
  );
}

void _handleMarkCallback(
  TeleDart teledart,
  TeleDartCallbackQuery callback,
) async {
  if (callback.data == MarkCommands.cancel.value) {
    _markModeEnabled = false;
    final deleteRequest = teledart.deleteMessage(
      callback.message?.chat.id,
      callback.message!.messageId,
    );
    final deleteMessage = teledart.deleteMessage(
      _markRequestMessage!.chat.id,
      _markRequestMessage!.messageId,
    );
    await Future.wait([deleteRequest, deleteMessage]);
    _markRequestMessage = null;
    return;
  }
  if (callback.data == MarkCommands.confirm.value) {
    _markModeEnabled = false;

    final markedGames = _markedGames.entries
        .where((element) => element.value)
        .map((e) => e.key.name)
        .join(', ');

    // TODO: update play counted

    await _markRequestMessage!.reply('Marked: $markedGames');
    teledart.deleteMessage(
      callback.message?.chat.id,
      callback.message!.messageId,
    );

    _markRequestMessage = null;
    return;
  }

  final game = callback.data!;

  final gameRef =
      _markedGames.entries.firstWhere((element) => element.key.name == game);
  _markedGames.remove(gameRef.key);
  _markedGames.addEntries([MapEntry(gameRef.key, !gameRef.value)]);
}
