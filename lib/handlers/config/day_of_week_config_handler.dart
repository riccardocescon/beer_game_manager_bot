part of '../../beer_game_manager_bot.dart';

String get _pollDayOfWeekFormatError =>
    'Invalid day of week format, please select one of the given options.';

void _setPollDayOfWeek(TeleDart teleDart) async {
  if (!_configModeEnabled) return;

  _currentConfigOption = _ConfigOption.pollDayOfWeek;

  final currentDayOfWeek = BotConfig.instance.dayOfWeekToStartPoll;

  await _updateMessage(
    teleDart,
    'Which day of the week should the poll run?\nCurrently: $currentDayOfWeek',
    replyMarkup: InlineKeyboardMarkup(
      inlineKeyboard: [
        [
          InlineKeyboardButton(
            text: date_time_utils.DaysOfWeek.monday.name,
            callbackData: date_time_utils.DaysOfWeek.monday.value.toString(),
          ),
          InlineKeyboardButton(
            text: date_time_utils.DaysOfWeek.tuesday.name,
            callbackData: date_time_utils.DaysOfWeek.tuesday.value.toString(),
          )
        ],
        [
          InlineKeyboardButton(
            text: date_time_utils.DaysOfWeek.wednesday.name,
            callbackData: date_time_utils.DaysOfWeek.wednesday.value.toString(),
          ),
          InlineKeyboardButton(
            text: date_time_utils.DaysOfWeek.thursday.name,
            callbackData: date_time_utils.DaysOfWeek.thursday.value.toString(),
          )
        ],
        [
          InlineKeyboardButton(
            text: date_time_utils.DaysOfWeek.friday.name,
            callbackData: date_time_utils.DaysOfWeek.friday.value.toString(),
          ),
          InlineKeyboardButton(
            text: date_time_utils.DaysOfWeek.saturday.name,
            callbackData: date_time_utils.DaysOfWeek.saturday.value.toString(),
          )
        ],
        [
          InlineKeyboardButton(
            text: date_time_utils.DaysOfWeek.sunday.name,
            callbackData: date_time_utils.DaysOfWeek.sunday.value.toString(),
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

  final selectedDayOfWeek = date_time_utils.DaysOfWeek.values
      .firstWhere((element) => element.value == dayOfWeek);

  BotConfig.instance.dayOfWeekToStartPoll = selectedDayOfWeek;

  await _currentConfigMessage!.reply(
    'Poll day of week set to ${selectedDayOfWeek.name}',
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
