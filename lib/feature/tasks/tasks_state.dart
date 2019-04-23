import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_todo/data/data.dart';

enum TasksFilter { all, active, completed }

Function _tasksEq = const ListEquality<Task>().equals;

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasksState &&
          runtimeType == other.runtimeType &&
          _tasksEq(tasks, other.tasks) &&
          filter == other.filter &&
          taskSort == other.taskSort;

  @override
  int get hashCode => tasks.hashCode ^ filter.hashCode ^ taskSort.hashCode;

  @override
  String toString() {
    return 'TasksState{tasks: $tasks, filter: $filter, taskSort: $taskSort}';
  }
}
