part of '../../beer_game_manager_bot.dart';

String get _pollDurationFormatError =>
    'Invalid duration format, please use HH:mm:ss format.';

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
