import 'package:beer_game_manager_bot/entities/scheduled_poll.dart';
import 'package:beer_game_manager_bot/utils/all_games.dart' as games_util;
import 'package:intl/intl.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

import 'config/bot_config.dart';

part 'handlers/poll_handler.dart';
part 'handlers/count_down_handler.dart';
part 'handlers/config_handler.dart';

Future<void> handlerBGMB(TeleDart teledart) async {
  final messageHandler = messageStreamer(teledart);
  final commandHandler = commandStreamer(teledart);
  final callbackQueryHandler = callbackQueryStreamer(teledart);

  await Future.wait([messageHandler, commandHandler, callbackQueryHandler]);
}

Future<void> messageStreamer(TeleDart teledart) async {
  final messageStream = teledart.onMessage();
  await for (final message in messageStream) {
    print('Received message: ${message.text}');
    if (_configModeEnabled) {
      _handleConfigMessage(
        teledart,
        callbackData: null,
        message: message,
      );
      return;
    }
  }
}

Future<void> commandStreamer(TeleDart teledart) async {
  final messageStream = teledart.onCommand();

  await for (final message in messageStream) {
    print('Received command: ${message.text}');
    if (message.text == '/manage') {
      _handlePoll(teledart, message);
    } else if (message.text == '/info') {
      _printRemainingPollTime(teledart);
    } else if (message.text == '/config') {
      _configHandler(teledart, message);
    }
  }
}

Future<void> callbackQueryStreamer(TeleDart teleDart) async {
  final callbackQueryStream = teleDart.onCallbackQuery();
  await for (final callbackQuery in callbackQueryStream) {
    print('Received callbackQuery');
    if (_configModeEnabled) {
      _handleConfigMessage(
        teleDart,
        callbackData: callbackQuery,
        message: null,
      );
      return;
    }

    if (callbackQuery.data == 'info') {
      _updateRemainingPollTime(teleDart);
    }
  }
}
