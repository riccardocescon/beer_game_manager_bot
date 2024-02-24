part of '../../beer_game_manager_bot.dart';

//#region Vars
bool _botRunning = false;
Timer? _remainingPollTimeTimer;
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

void _autoHandlePoll(TeleDart teledart, TeleDartMessage message) async {
  if (_botRunning) {
    final botMessage = await message.reply('Bot already running');
    await teledart.deleteMessage(
      message.chat.id,
      message.messageId,
    );
    teledart.deleteMessage(
      botMessage.chat.id,
      botMessage.messageId,
    );

    return;
  }

  _botRunning = true;
  while (_botRunning) {
    final now = DateTime.now();
    final weekDayToStartPoll = Bot.instance.config.dayOfWeekToStartPoll.value;
    final currentWeekDay = now.weekday;
    int remainingDays = weekDayToStartPoll - currentWeekDay;
    if (remainingDays < 0) remainingDays += 7;
    final nowLaunch = now.copyWith(
      hour: 12,
      minute: 0,
      second: 0,
    );
    final requestPollDateTime = nowLaunch.add(Duration(days: remainingDays));

    final nextPollFormatted = DateFormat('dd/MM/yyyy HH:mm').format(
      requestPollDateTime,
    );
    message.reply('Next poll will start on: $nextPollFormatted');

    _remainingPollTimeTimer = Timer(
      requestPollDateTime.difference(now),
      () async {
        await _handlePoll(teledart, message);
        _killTimer();
      },
    );

    while (_remainingPollTimeTimer != null) {
      await Future.delayed(Duration(seconds: 1));
    }
  }
}

void _killTimer() {
  _remainingPollTimeTimer?.cancel();
  _remainingPollTimeTimer = null;
}

void _restartAutoHandlePoll() {
  _killTimer();
}

void _killPoll(TeleDart teledart, TeleDartMessage message) {
  _botRunning = false;
  _killTimer();
  _currentPoll = null;
  message.reply(
    'Auto Poll Killed.\n Use the Hub messages to start a new poll',
  );
}

Future<void> _handlePoll(TeleDart teledart, TeleDartMessage message) async {
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

  final deadline = DateTime.now().add(Bot.instance.config.pollDuration);
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
    message.reply('No game found for $players players');
    return;
  }

  final sortedGames = game_sorter.sortGamesByPlayCount(games, true);

  message.reply(
    'Poll ended with $players players\n'
    'Here\'s a list of games suitable for $players players:\n\n'
    '- ${sortedGames.map((e) => e.log).join('\n\n')}',
  );
}
//#endregion



