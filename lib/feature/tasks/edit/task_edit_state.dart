import 'package:flutter_bloc_todo/data/source/entity/task.dart';
import 'package:meta/meta.dart';

@immutable
class TaskEditState {
  const TaskEditState({
    this.title = '',
    this.description = '',
  });

  factory TaskEditState.fromTask(Task task) {
    assert(task != null);
    return TaskEditState(
      title: task.title,
      description: task.description,
    );
  }

  final String title;
  final String description;

  bool get isCompleted => title?.isNotEmpty ?? false;
}
