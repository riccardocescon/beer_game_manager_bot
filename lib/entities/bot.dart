import 'package:beer_game_manager_bot/config/bot_config.dart';

class Bot {
  late BotConfig _config;

  Bot._() {
    _config = BotConfig();
  }

  static final Bot _instance = Bot._();
  static Bot get instance => _instance;

  BotConfig get config => _config;
}
