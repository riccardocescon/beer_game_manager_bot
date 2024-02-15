import 'dart:async';

import 'dart:core';
import 'package:beer_game_manager_bot/entities/bot.dart';
import 'package:beer_game_manager_bot/entities/scheduled_poll.dart';
import 'package:beer_game_manager_bot/utils/hub_messages.dart';
import 'package:beer_game_manager_bot/utils/all_games.dart' as games_util;
import 'package:beer_game_manager_bot/utils/commands.dart';
import 'package:beer_game_manager_bot/utils/date_time_utils.dart'
    as date_time_utils;
import 'package:intl/intl.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

part 'handlers/poll/poll_handler.dart';
part 'handlers/poll/count_down_handler.dart';

part 'handlers/config/config_handler.dart';
part 'handlers/hub/hub_handler.dart';
part 'handlers/config/duration_config_handler.dart';
part 'handlers/config/day_of_week_config_handler.dart';

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
      if (HubMessage.values.any((element) => element.message == message.text)) {
        teledart.deleteMessage(message.chat.id, message.messageId);
        continue;
      }
      _handleConfigMessage(
        teledart,
        callbackData: null,
        message: message,
      );
      continue;
    }

    _handleHubMessage(teledart, message);
  }
}

Future<void> commandStreamer(TeleDart teledart) async {
  final messageStream = teledart.onCommand();

  await for (final message in messageStream) {
    if (_configModeEnabled) return;
    print('Received command: ${message.text}');
    if (message.text == '/start') {
      // _autoHandlePoll(teledart, message);
      _sendHubMessage(teledart, message);
      continue;
    }

    if (message.text == '/manage') {
      _handlePoll(teledart, message);
      continue;
    }

    if (message.text == '/info') {
      _printBotConfigInfo(teledart, message);
      continue;
    }

    if (message.text == '/config') {
      _configHandler(teledart, message);
      continue;
    }

    if (message.text == '/kill') {
      _killPoll(teledart, message);
      continue;
    }
  }
}

void _sendHubMessage(TeleDart teleDart, TeleDartMessage message) {
  message.reply(
    'You\'re in the hub! What do you want to do?',
    replyMarkup: ReplyKeyboardMarkup(
      keyboard: [
        [
          KeyboardButton(text: HubMessage.manualPoll.message),
        ],
        [
          KeyboardButton(text: HubMessage.configInfo.message),
          KeyboardButton(text: HubMessage.editConfig.message),
        ],
        [
          KeyboardButton(text: HubMessage.startAutoPoll.message),
          KeyboardButton(text: HubMessage.killAutoPoll.message),
        ],
      ],
    ),
  );
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
      continue;
    }

    if (callbackQuery.data == 'info') {
      _updateRemainingPollTime(teleDart);
    }
  }
}

Future<void> _printBotConfigInfo(
  TeleDart teleDart,
  TeleDartMessage message,
) async {
  final config = Bot.instance.config;
  final pollDuration = config.formattedPollDuration;
  final pollDayOfWeek = config.dayOfWeekToStartPoll.name;
  final pollRunningStatus = _currentPoll == null
      ? 'No poll running'
      : 'Poll running until ${DateFormat('dd/MM/yyyy - HH:mm').format(_currentPoll!.deadline)}';
  final text = 'Bot configuration:\n'
      'Status: $pollRunningStatus\n'
      'Poll duration: $pollDuration\n'
      'Poll day of week: $pollDayOfWeek';
  await message.reply(text);
}
