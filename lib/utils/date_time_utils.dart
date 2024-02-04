enum DaysOfWeek {
  monday(1, 'Monday'),
  tuesday(2, 'Tuesday'),
  wednesday(3, 'Wednesday'),
  thursday(4, 'Thursday'),
  friday(5, 'Friday'),
  saturday(6, 'Saturday'),
  sunday(7, 'Sunday');

  const DaysOfWeek(this.value, this.name);
  final int value;
  final String name;
}

int getDayOfWeek(int day) {
  return DaysOfWeek.values.firstWhere((element) => element.value == day).value;
}
