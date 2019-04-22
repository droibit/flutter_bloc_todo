import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:flutter_bloc_todo/feature/bloc_base.dart';
import 'package:flutter_bloc_todo/feature/tasks/tasks_bloc_event.dart';
import 'package:flutter_bloc_todo/feature/tasks/tasks_state.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

typedef _Compare<T> = int Function(T a, T b);

@immutable
class TasksBloc extends SimpleBlocBase {
  TasksBloc({
    @required TaskRepository taskRepository,
    @required UserSettingsRepository userSettingsRepository,
  })  : assert(taskRepository != null),
        assert(userSettingsRepository != null),
        _taskRepository = taskRepository,
        _userSettingsRepository = userSettingsRepository,
        _taskFilterSubject = BehaviorSubject.seeded(TasksFilter.all);

  final TaskRepository _taskRepository;

  final UserSettingsRepository _userSettingsRepository;

  final BehaviorSubject<TasksFilter> _taskFilterSubject;

  Observable<TasksState> get tasksState {
    return Observable.combineLatest3(
      _taskRepository.tasks,
      _taskFilterSubject,
      _userSettingsRepository.taskSort,
      (List<Task> tasks, TasksFilter filter, TaskSort taskSort) {
        return TasksState(
          tasks: _filterTasks(tasks, filter)..sort(_resolveCompare(taskSort)),
          filter: filter,
          taskSort: taskSort,
        );
      },
    );
  }

  List<Task> _filterTasks(List<Task> src, TasksFilter filter) {
    return src.where((task) {
      switch (filter) {
        case TasksFilter.all:
          return true;
        case TasksFilter.active:
          return task.isActive;
        case TasksFilter.completed:
          return task.completed;
      }
    }).toList(growable: false);
  }

  _Compare<Task> _resolveCompare(TaskSort tasksSort) {
    switch (tasksSort.by) {
      case SortBy.title:
        return (tasksSort.order == Order.asc)
            ? (lhs, rhs) => lhs.title.compareTo(rhs.title)
            : (lhs, rhs) => rhs.title.compareTo(lhs.title);
      case SortBy.created_date:
        return (tasksSort.order == Order.asc)
            ? (lhs, rhs) => lhs.timestamp.compareTo(rhs.timestamp)
            : (lhs, rhs) => rhs.timestamp.compareTo(lhs.timestamp);
      default:
        throw AssertionError('Invalid sort by: ${tasksSort.by}');
    }
  }

  @override
  void onHandleEvent(BlocEvent event) {
    if (event is ChangeTasksFilterEvent) {
      _onChangeTasksFilterEvent(event);
    } else if (event is ChangeTaskSortEvent) {
      _onChangeTaskSortEvent(event);
    } else if (event is ChangeTaskCompletedEvent) {
      _onChangeTaskCompletedEvent(event);
    } else if (event is ClearCompletedTasksEvent) {
      _onClearCompletedTasksEvent(event);
    } else {
      throw ArgumentError('Unknown event: ${event.runtimeType}');
    }
  }

  void _onChangeTasksFilterEvent(ChangeTasksFilterEvent event) {
    Logger.log('onChangeTasksFilterEvent(filter=${event.filter})');
    _taskFilterSubject.add(event.filter);
  }

  void _onChangeTaskSortEvent(ChangeTaskSortEvent event) {
    Logger.log('onChangeTaskSortEvent(taskSort=${event.taskSort})');

    if (event.taskSort != _userSettingsRepository.taskSort.value) {
      _userSettingsRepository.storeTasksSort(event.taskSort);
    }
  }

  void _onChangeTaskCompletedEvent(ChangeTaskCompletedEvent event) {
    Logger.log(
        'onChangeTaskCompletedEvent(task=${event.id}, completed=${event.completed})');
    if (event.completed) {
      _taskRepository.completeTask(event.id);
    } else {
      _taskRepository.activateTask(event.id);
    }
  }

  void _onClearCompletedTasksEvent(ClearCompletedTasksEvent event) {
    Logger.log('onClearCompletedTasksEvent()');
    _taskRepository.clearCompletedTasks();
  }

  @override
  void dispose() {
    _taskFilterSubject.close();
    super.dispose();
  }
}

@immutable
class TasksBlocProvider extends BlocProvider<TasksBloc> {
  TasksBlocProvider({
    @required Widget child,
  })  : assert(child != null),
        super(
          creator: (context, _) {
            final deps = DependencyProvider.of(context);
            return TasksBloc(
              taskRepository: deps.taskRepository,
              userSettingsRepository: deps.userSettingsRepository,
            );
          },
          child: child,
        );

  static TasksBloc of(BuildContext context) => BlocProvider.of(context);
}
