class BotConfig {
  Duration _pollDuration = Duration(seconds: 10);
  int _dayOfWeekToStartPoll = 1;

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
  int get dayOfWeekToStartPoll => _dayOfWeekToStartPoll;

  set pollDuration(Duration value) {
    _pollDuration = value;
  }

  set dayOfWeekToStartPoll(int value) {
    _dayOfWeekToStartPoll = value;
  }
}
