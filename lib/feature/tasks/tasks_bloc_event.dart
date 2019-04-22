import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/feature/bloc_base.dart';
import 'package:flutter_bloc_todo/feature/tasks/tasks_state.dart';

@immutable
class ChangeTasksFilterEvent implements BlocEvent {
  const ChangeTasksFilterEvent(this.filter) : assert(filter != null);

  final TasksFilter filter;
}

@immutable
class ChangeTaskSortEvent implements BlocEvent {
  const ChangeTaskSortEvent(this.taskSort) : assert(taskSort != null);

  final TaskSort taskSort;
}

@immutable
class ChangeTaskCompletedEvent implements BlocEvent {
  const ChangeTaskCompletedEvent({
    @required this.id,
    @required this.completed,
  })  : assert(id != null),
        assert(completed != null);

  final String id;
  final bool completed;
}

@immutable
class ClearCompletedTasksEvent implements BlocEvent {
  factory ClearCompletedTasksEvent() {
    _instance ??= ClearCompletedTasksEvent();
    return _instance;
  }

  static ClearCompletedTasksEvent _instance;
}
