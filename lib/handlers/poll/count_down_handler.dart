part of '../../beer_game_manager_bot.dart';

Message? _countdownMessage;

String _formatRemainingRunningTimeSentence(Duration remainingTime) {
  final hours = remainingTime.inHours.remainder(60).toString().padLeft(2, '0');
  final minutes =
      remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds =
      remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');

  final endDate = DateTime.now().add(remainingTime);

  return 'Poll willl end: ${DateFormat('dd/MM HH:mm').format(endDate)}'
      '\nRemainingTime: $hours:$minutes:$seconds';
}

String get _errorNoPullRunning => 'No poll running';

Future<void> _printRemainingPollTime(TeleDart teledart) async {
  try {
    final remainingTime = _remeainingPollTime;
    if (remainingTime == null) {
      await _currentPoll?.message.reply(_errorNoPullRunning);
      return;
    }

    _countdownMessage = await _currentPoll?.message.reply(
      _formatRemainingRunningTimeSentence(remainingTime),
    );

    return;
  } catch (_) {}
}

Future<void> _updateRemainingPollTime(TeleDart teledart) async {
  try {
    final remainingTime = _remeainingPollTime;
    if (remainingTime == null) {
      _currentPoll?.message.reply(_errorNoPullRunning);
      return;
    }

    if (_countdownMessage == null) return;

    await teledart.editMessageText(
      _formatRemainingRunningTimeSentence(remainingTime),
      chatId: _countdownMessage!.chat.id,
      messageId: _countdownMessage!.messageId,
    );
  } catch (_) {}
}

Future<void> _deleteRemainingPollTime(TeleDart teledart) async {
  try {
    if (_countdownMessage == null) return;
    await teledart.deleteMessage(
      _countdownMessage!.chat.id,
      _countdownMessage!.messageId,
    );
    _countdownMessage = null;
  } catch (_) {}
}
