enum HubMessage {
  manualPoll._('Manual Poll'),
  configInfo._('Config Info'),
  editConfig._('Edit Config'),
  startAutoPoll._('Start Auto Poll'),
  killAutoPoll._('Kill Auto Poll'),
  mark._('Mark'),
  stats._('Stats'),
  deleteDB._('D3l3T3_DB'),
  ;

  const HubMessage._(this.message);
  final String message;
}
