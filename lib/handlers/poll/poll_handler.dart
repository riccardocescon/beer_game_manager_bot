part of '../../beer_game_manager_bot.dart';

//#region Vars
ScheduledPoll? _currentPoll;
Duration? get _remeainingPollTime {
  if (_currentPoll == null) {
    return null;
  }

  final now = DateTime.now();
  final diff = _currentPoll!.deadline.difference(now);
  return diff;
}
//#endregion

//#region API

void _handlePoll(TeleDart teledart, TeleDartMessage message) async {
  if (_currentPoll != null) {
    final alreadyRunning =
        await message.reply('There is a Poll already running, daaaaahhhhh');
    await Future.delayed(Duration(seconds: 3));
    teledart.deleteMessage(alreadyRunning.chat.id, alreadyRunning.messageId);
    teledart.deleteMessage(message.chat.id, message.messageId);
    return;
  }
  await _startPoll(teledart, message);
  await _handleCompletedPoll(
    teledart,
    message,
  );
}

//#endregion

//#region Handlers
Future<void> _startPoll(
  TeleDart teledart,
  TeleDartMessage message,
) async {
  final poll = await teledart.sendPoll(
    message.chat.id,
    'Partecipi alla serata Birra e Giochi?',
    [
      'Ci sono',
      'Non ci sono',
    ],
    isAnonymous: false,
    allowsMultipleAnswers: false,
    replyMarkup: InlineKeyboardMarkup(
      inlineKeyboard: [
        [
          InlineKeyboardButton(
            text: 'Info',
            callbackData: 'info',
          ),
        ],
      ],
    ),
  );

  final deadline = DateTime.now().add(BotConfig.instance.pollDuration);
  _currentPoll = ScheduledPoll(
    poll.messageId.toString(),
    deadline,
    message,
  );
  await _currentPoll!.start(
    onStart: () {
      _printRemainingPollTime(teledart);
    },
    onComplete: () {
      _deleteRemainingPollTime(teledart);
    },
  );
}

Future<void> _handleCompletedPoll(
  TeleDart teledart,
  TeleDartMessage message,
) async {
  if (_currentPoll == null) {
    message.reply('No poll running, ignoring completePoll handling');
    return;
  }

  final pollResults = await teledart.stopPoll(
    message.chat.id,
    int.parse(_currentPoll!.pollId),
    replyMarkup: _currentPoll!.message.replyMarkup,
  );

  _currentPoll = null;

  final players =
      pollResults.options.firstWhere((e) => e.text == 'Ci sono').voterCount;
  final games = games_util.gamesForPlayers(players);

  if (games.isEmpty) {
    message.reply('Nessun gioco trovato per $players giocatori');
    return;
  }

  message.reply(
    'Poll ended with $players players\n'
    'Here\'s a list of games suitable for $players players:\n\n'
    '- ${games.map((e) => e.name).join('\n')}',
  );
}
//#endregion



