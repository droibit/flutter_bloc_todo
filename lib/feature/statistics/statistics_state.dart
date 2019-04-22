import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_todo/data/data.dart';

@immutable
class StatisticsState {
  const StatisticsState({
    this.activeCount,
    this.completedCount,
  });

  factory StatisticsState.fromTasks(List<Task> tasks) {
    assert(tasks != null);

    final activeCount = tasks.where((task) => task.isActive).length;
    return StatisticsState(
      activeCount: activeCount,
      completedCount: tasks.length - activeCount,
    );
  }

  final int activeCount;
  final int completedCount;

  bool get hasNotTask => activeCount == 0 && completedCount == 0;
}
