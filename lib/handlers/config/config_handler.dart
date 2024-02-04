part of '../../beer_game_manager_bot.dart';

bool _configModeEnabled = false;
TeleDartMessage? _currentConfigMessage;
Message? _inlineMessage;

enum _ConfigOption {
  none,
  pollDuration,
  pollDayOfWeek,
  ;
}

_ConfigOption _currentConfigOption = _ConfigOption.none;

void _handleConfigMessage(
  TeleDart teleDart, {
  required TeleDartCallbackQuery? callbackData,
  required Message? message,
}) {
  final isPollDuration = _currentConfigOption == _ConfigOption.pollDuration;
  if (isPollDuration) {
    _setPollDurationValue(teleDart, message!);
    return;
  }

  final isPollDayOfWeek = _currentConfigOption == _ConfigOption.pollDayOfWeek;
  if (isPollDayOfWeek) {
    _setPollDayOfWeekValue(teleDart, callbackData!);
    return;
  }

  _handleFirstRequest(teleDart, callbackData!.data);
}

void _handleFirstRequest(TeleDart teleDart, String? data) {
  if (data == 'poll_duration') {
    _setPollDuration(teleDart);
    return;
  } else if (data == 'poll_day_of_week') {
    _setPollDayOfWeek(teleDart);
    return;
  } else if (data == 'exit_config_mode') {
    _exitConfigMode(teleDart);
    return;
  }

  _currentConfigMessage!.reply('Invalid option, please try again.');
}

void _configHandler(
  TeleDart teleDart,
  TeleDartMessage message, {
  bool autoRequest = false,
}) async {
  _configModeEnabled = true;
  _currentConfigMessage = message;
  _currentConfigOption = _ConfigOption.none;
  final text =
      'You are now in configuration mode. What do you want to configure?';
  final replyMarkup = InlineKeyboardMarkup(
    inlineKeyboard: [
      [
        InlineKeyboardButton(
          text: 'Poll Duration',
          callbackData: 'poll_duration',
        ),
        InlineKeyboardButton(
          text: 'Poll Day of Week',
          callbackData: 'poll_day_of_week',
        ),
        InlineKeyboardButton(
          text: 'Exit',
          callbackData: 'exit_config_mode',
        ),
      ],
    ],
  );

  if (autoRequest) {
    _inlineMessage = await teleDart.editMessageText(
      text,
      chatId: _inlineMessage!.chat.id,
      messageId: _inlineMessage!.messageId,
      replyMarkup: replyMarkup,
    );
  } else {
    _inlineMessage = await _currentConfigMessage!.reply(
      text,
      replyMarkup: replyMarkup,
    );
  }
}

void _exitConfigMode(TeleDart teleDart) {
  teleDart.deleteMessage(
    _inlineMessage!.chat.id,
    _inlineMessage!.messageId,
  );
  _currentConfigMessage?.reply('Exited configuration mode');
  _currentConfigMessage = null;
  _inlineMessage = null;
  _configModeEnabled = false;
}

Future<void> _updateMessage(
  TeleDart teleDart,
  String message, {
  InlineKeyboardMarkup? replyMarkup,
}) async {
  await teleDart.editMessageText(
    message,
    chatId: _inlineMessage!.chat.id,
    messageId: _inlineMessage!.messageId,
    replyMarkup: replyMarkup,
  );
}
