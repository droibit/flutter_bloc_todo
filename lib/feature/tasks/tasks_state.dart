import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_todo/data/data.dart';

enum TasksFilter { all, active, completed }

@immutable
class TasksState {
  const TasksState({
    @required this.tasks,
    @required this.filter,
    @required this.taskSort,
  });

  final List<Task> tasks;
  final TasksFilter filter;
  final TaskSort taskSort;
}
