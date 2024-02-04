import 'package:beer_game_manager_bot/utils/date_time_utils.dart'
    as date_time_utils;

class BotConfig {
  Duration _pollDuration = Duration(seconds: 10);
  date_time_utils.DaysOfWeek _dayOfWeekToStartPoll =
      date_time_utils.DaysOfWeek.monday;

  BotConfig._();

  static final BotConfig _instance = BotConfig._();
  static BotConfig get instance => _instance;

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
}
