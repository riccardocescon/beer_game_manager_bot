enum ConfigCommands {
  pollDuration('poll_duration'),
  pollDayOfWeek('poll_day_of_week'),
  exitConfigMode('exit_config_mode'),
  cancelConfig('cancel_config');

  const ConfigCommands(this.value);
  final String value;
}
