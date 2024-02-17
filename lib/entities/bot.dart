import 'dart:io';

import 'package:beer_game_manager_bot/config/bot_config.dart';
import 'package:beer_game_manager_bot/utils/paths.dart' as path_config;

class Bot {
  late BotConfig _config;

  static final _configFile = File(path_config.Paths.botConfig);

  Bot._({required BotConfig config}) : _config = config;

  factory Bot.fromConfig(BotConfig config) {
    return _instance = Bot._(config: config);
  }

  static late final Bot _instance;
  static Bot get instance => _instance;

  BotConfig get config => _config;

  static void setup() {
    if (!_configFile.existsSync()) {
      final newConfig = BotConfig.defaultConfig();
      _configFile.writeAsStringSync(newConfig.toFile());
    }

    final content = _configFile.readAsStringSync();
    final config = BotConfig.fromFile(content);
    Bot.fromConfig(config);

    print('Loaded config: ${config.toFile()}');
  }

  void updateConfigFile() {
    _configFile.writeAsStringSync(_config.toFile());
  }
}
