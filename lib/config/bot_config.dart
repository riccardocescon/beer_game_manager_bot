import 'dart:convert';

import 'package:beer_game_manager_bot/utils/date_time_utils.dart'
    as date_time_utils;

class BotConfig {
  late Duration _pollDuration;
  late date_time_utils.DaysOfWeek _dayOfWeekToStartPoll;

  String get formattedPollDuration {
    final hours =
        _pollDuration.inHours.remainder(60).toString().padLeft(2, '0');
    final minutes =
        _pollDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        _pollDuration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  Duration get pollDuration => _pollDuration;
  date_time_utils.DaysOfWeek get dayOfWeekToStartPoll => _dayOfWeekToStartPoll;

  set pollDuration(Duration value) {
    _pollDuration = value;
  }

  set dayOfWeekToStartPoll(date_time_utils.DaysOfWeek value) {
    _dayOfWeekToStartPoll = value;
  }

  BotConfig._({
    required Duration duration,
    required date_time_utils.DaysOfWeek dayOfWeek,
  })  : _pollDuration = duration,
        _dayOfWeekToStartPoll = dayOfWeek;

  factory BotConfig.fromFile(String jsonContent) {
    final data = jsonDecode(jsonContent);
    final duration = Duration(seconds: data['pollDuration']);
    final dayOfWeek =
        date_time_utils.DaysOfWeek.values[data['dayOfWeekToStartPoll']];

    return BotConfig._(duration: duration, dayOfWeek: dayOfWeek);
  }

  factory BotConfig.defaultConfig() {
    return BotConfig._(
      duration: Duration(days: 1),
      dayOfWeek: date_time_utils.DaysOfWeek.monday,
    );
  }

  String toFile() {
    final data = {
      'pollDuration': _pollDuration.inSeconds,
      'dayOfWeekToStartPoll': _dayOfWeekToStartPoll.index,
    };

    return jsonEncode(data);
  }
}
