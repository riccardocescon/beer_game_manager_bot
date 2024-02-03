part of '../beer_game_manager_bot.dart';

bool _configModeEnabled = false;
TeleDartMessage? _currentConfigMessage;
Message? _inlineMessage;

String get _pollDurationFormatError =>
    'Invalid duration format, please use HH:mm:ss format.';

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
  if (_currentConfigOption == _ConfigOption.pollDuration) {
    _setPollDurationValue(teleDart, message!);
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

void _setPollDuration(TeleDart teleDart) async {
  if (!_configModeEnabled || _currentConfigMessage == null) return;

  _currentConfigOption = _ConfigOption.pollDuration;

  await _updateMessage(
    teleDart,
    'How long should the poll last? (HH:mm:ss)',
  );
}

void _setPollDurationValue(TeleDart teleDart, Message message) async {
  if (!_configModeEnabled || _currentConfigMessage == null) return;

  final text = message.text;
  if (text == null) {
    await _currentConfigMessage!.reply(_pollDurationFormatError);
    return;
  }
  final hours = int.tryParse(text.split(':')[0]);
  if (hours == null || hours < 0) {
    await _currentConfigMessage!.reply(_pollDurationFormatError);
    return;
  }

  final minutes = int.tryParse(text.split(':')[1]);
  if (minutes == null || minutes < 0) {
    await _currentConfigMessage!.reply(_pollDurationFormatError);
    return;
  }

  final seconds = int.tryParse(text.split(':')[2]);
  if (seconds == null || seconds < 0) {
    await _currentConfigMessage!.reply(_pollDurationFormatError);
    return;
  }

  final duration = Duration(hours: hours, minutes: minutes, seconds: seconds);

  BotConfig.instance.pollDuration = duration;

  await _currentConfigMessage!.reply('Poll duration set to $text');

  teleDart.deleteMessage(
    message.chat.id,
    message.messageId,
  );

  teleDart.deleteMessage(
    _inlineMessage!.chat.id,
    _inlineMessage!.messageId,
  );

  _configHandler(
    teleDart,
    _currentConfigMessage!,
  );
}

void _setPollDayOfWeek(TeleDart teleDart) async {
  if (!_configModeEnabled) return;
  // await message.reply(
  //   'Enter the new day of week to start the poll',
  //   replyMarkup: ForceReply(),
  // );
}

void _exitConfigMode(TeleDart teleDart) {
  _configModeEnabled = false;
}

Future<void> _updateMessage(TeleDart teleDart, String message) async {
  await teleDart.editMessageText(
    message,
    chatId: _inlineMessage!.chat.id,
    messageId: _inlineMessage!.messageId,
  );
}
