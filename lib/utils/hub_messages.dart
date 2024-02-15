enum HubMessage {
  manualPoll._('Manual Poll'),
  configInfo._('Config Info'),
  editConfig._('Edit Config'),
  startAutoPoll._('Start Auto Poll'),
  killAutoPoll._('Kill Auto Poll'),
  mark._('Mark'),
  ;

  const HubMessage._(this.message);
  final String message;
}
