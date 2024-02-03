import 'package:beer_game_manager_bot/beer_game_manager_bot.dart'
    as beer_game_manager_bot;
import 'package:dotenv/dotenv.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

void main(List<String> arguments) async {
  var env = DotEnv(includePlatformEnvironment: true)..load();
  final botToken = env['BOT_TOKEN']!;

  final username = (await Telegram(botToken).getMe()).username;
  final teledart = TeleDart(botToken, Event(username!));

  teledart.start();

  await beer_game_manager_bot.handlerBGMB(teledart);

  teledart.stop();
}
