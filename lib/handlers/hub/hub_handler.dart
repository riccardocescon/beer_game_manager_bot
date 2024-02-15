part of '../../beer_game_manager_bot.dart';

_handleHubMessage(TeleDart teledart, TeleDartMessage message) {
  if (message.text == HubMessage.manualPoll.message) {
    _handlePoll(teledart, message);
  } else if (message.text == HubMessage.mark.message) {
    _markHandler(teledart, message);
  } else if (message.text == HubMessage.stats.message) {
    _printGamesStats(teledart, message);
  } else if (message.text == HubMessage.configInfo.message) {
    _printBotConfigInfo(teledart, message);
  } else if (message.text == HubMessage.editConfig.message) {
    _configHandler(teledart, message);
  } else if (message.text == HubMessage.startAutoPoll.message) {
    _autoHandlePoll(teledart, message);
  } else if (message.text == HubMessage.killAutoPoll.message) {
    _killPoll(teledart, message);
  } else if (message.text == deleteDBCommand) {
    BeerDatabase.instance.deleteDB();
    message
        .reply('Database deleted! Requested by ${message.from?.username}')
        .then(
          (value) => teledart.deleteMessage(message.chat.id, message.messageId),
        );
  }
}
