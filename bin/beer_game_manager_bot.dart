import 'package:beer_game_manager_bot/beer_game_manager_bot.dart'
    as beer_game_manager_bot;
import 'package:beer_game_manager_bot/entities/bot.dart' as bot;
import 'package:dotenv/dotenv.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:beer_game_manager_bot/database/database.dart' as db;

void main(List<String> arguments) async {
  try {
    db.BeerDatabase.instance
        .setup(dbVersion: db.BeerDatabase.instance.dbVersion);

    bot.Bot.setup();

    var env = DotEnv(includePlatformEnvironment: true)..load();
    final botToken = env['BOT_TOKEN']!;
    beer_game_manager_bot.deleteDBCommand = env['DELETE_DB']!;

    final username = (await Telegram(botToken).getMe()).username;
    final teledart = TeleDart(botToken, Event(username!));

    teledart.start();

    await beer_game_manager_bot.handlerBGMB(teledart);

    teledart.stop();
  } catch (e) {
    print(e);
  }
}
