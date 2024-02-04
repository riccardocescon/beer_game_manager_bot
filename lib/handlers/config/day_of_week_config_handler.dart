part of '../../beer_game_manager_bot.dart';

String get _pollDayOfWeekFormatError =>
    'Invalid day of week format, please select one of the given options.';

Map<String, String> _daysOfWeek = {
  '1': 'Monday',
  '2': 'Tuesday',
  '3': 'Wednesday',
  '4': 'Thursday',
  '5': 'Friday',
  '6': 'Saturday',
  '7': 'Sunday',
};

void _setPollDayOfWeek(TeleDart teleDart) async {
  if (!_configModeEnabled) return;

  _currentConfigOption = _ConfigOption.pollDayOfWeek;

  final currentDayOfWeek = _daysOfWeek.entries
      .firstWhere((element) =>
          element.key == BotConfig.instance.dayOfWeekToStartPoll.toString())
      .value;

  await _updateMessage(
    teleDart,
    'Which day of the week should the poll run?\nCurrently: $currentDayOfWeek',
    replyMarkup: InlineKeyboardMarkup(
      inlineKeyboard: [
        [
          InlineKeyboardButton(
            text: _daysOfWeek.entries.elementAt(0).value,
            callbackData: _daysOfWeek.entries.elementAt(0).key,
          ),
          InlineKeyboardButton(
            text: _daysOfWeek.entries.elementAt(1).value,
            callbackData: _daysOfWeek.entries.elementAt(1).key,
          )
        ],
        [
          InlineKeyboardButton(
            text: _daysOfWeek.entries.elementAt(2).value,
            callbackData: _daysOfWeek.entries.elementAt(2).key,
          ),
          InlineKeyboardButton(
            text: _daysOfWeek.entries.elementAt(3).value,
            callbackData: _daysOfWeek.entries.elementAt(3).key,
          )
        ],
        [
          InlineKeyboardButton(
            text: _daysOfWeek.entries.elementAt(4).value,
            callbackData: _daysOfWeek.entries.elementAt(4).key,
          ),
          InlineKeyboardButton(
            text: _daysOfWeek.entries.elementAt(5).value,
            callbackData: _daysOfWeek.entries.elementAt(5).key,
          )
        ],
        [
          InlineKeyboardButton(
            text: _daysOfWeek.entries.elementAt(6).value,
            callbackData: _daysOfWeek.entries.elementAt(6).key,
          )
        ],
        [
          InlineKeyboardButton(
            text: 'Cancel',
            callbackData: Commands.cancelConfig.value,
          )
        ],
      ],
    ),
  );
}

void _setPollDayOfWeekValue(
  TeleDart teleDart,
  TeleDartCallbackQuery dataCallback,
) async {
  if (!_configModeEnabled || _currentConfigMessage == null) return;

  final text = dataCallback.data;
  if (text == null) {
    await _currentConfigMessage!.reply(_pollDayOfWeekFormatError);
    return;
  }

  final dayOfWeek = int.tryParse(text);
  if (dayOfWeek == null || dayOfWeek < 1 || dayOfWeek > 7) {
    await _currentConfigMessage!.reply(_pollDayOfWeekFormatError);
    return;
  }

  BotConfig.instance.dayOfWeekToStartPoll = dayOfWeek;

  final stringDayOfWeek =
      _daysOfWeek.entries.firstWhere((element) => element.key == text).value;
  await _currentConfigMessage!.reply(
    'Poll day of week set to $stringDayOfWeek',
  );

  teleDart.deleteMessage(
    dataCallback.message?.chat.id,
    dataCallback.message!.messageId,
  );

  _configHandler(
    teleDart,
    _currentConfigMessage!,
  );
}
