import 'package:teledart/model.dart';

typedef VoidCallback = void Function();

class ScheduledPoll {
  final String pollId;
  final DateTime deadline;
  final TeleDartMessage message;

  Future<void> start({
    required VoidCallback onStart,
    required VoidCallback onComplete,
  }) async {
    final now = DateTime.now();
    final diff = deadline.difference(now);
    onStart();
    await Future.delayed(diff);

    await Future.delayed(const Duration(seconds: 1));
    onComplete();
  }

  ScheduledPoll(this.pollId, this.deadline, this.message);
}
