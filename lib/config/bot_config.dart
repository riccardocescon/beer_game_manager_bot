class BotConfig {
  Duration _pollDuration = Duration(seconds: 10);
  int _dayOfWeekToStartPoll = 1;

  BotConfig._();

  static final BotConfig _instance = BotConfig._();
  static BotConfig get instance => _instance;

  Duration get pollDuration => _pollDuration;
  int get dayOfWeekToStartPoll => _dayOfWeekToStartPoll;

  set pollDuration(Duration value) {
    _pollDuration = value;
  }

  set dayOfWeekToStartPoll(int value) {
    _dayOfWeekToStartPoll = value;
  }
}
