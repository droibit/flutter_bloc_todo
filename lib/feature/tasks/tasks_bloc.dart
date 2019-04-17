import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:flutter_bloc_todo/feature/tasks/_common/task_completed.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

typedef _Compare<T> = int Function(T a, T b);

enum TasksFilter { all, active, completed }

class TasksBloc implements Bloc {
  TasksBloc({
    @required TaskRepository taskRepository,
    @required UserSettingsRepository userSettingsRepository,
  })  : assert(taskRepository != null),
        assert(userSettingsRepository != null),
        _taskRepository = taskRepository,
        _userSettingsRepository = userSettingsRepository,
        _taskFilterSubject = BehaviorSubject.seeded(TasksFilter.all),
        _taskSortController = PublishSubject(),
        _taskCompletedController = PublishSubject(),
        _clearCompletedTasksSubject = PublishSubject() {
    _taskSortController.stream.listen(_onTaskSortChanged);
    _taskCompletedController.listen(_onTaskCompleted);
    _clearCompletedTasksSubject.listen(_onClearCompletedTasks);
  }

  final TaskRepository _taskRepository;

  final UserSettingsRepository _userSettingsRepository;

  final BehaviorSubject<TasksFilter> _taskFilterSubject;

  final PublishSubject<TaskSort> _taskSortController;

  final PublishSubject<TaskCompleted> _taskCompletedController;

  final PublishSubject<void> _clearCompletedTasksSubject;

  Observable<TasksView> _tasksViewObservable;

  Observable<TasksView> get tasksView {
    _tasksViewObservable ??= Observable.combineLatest3(
      _taskRepository.tasks,
      _taskFilterSubject,
      _userSettingsRepository.taskSort,
      (List<Task> tasks, TasksFilter filter, TaskSort taskSort) {
        return TasksView(
          tasks: _filterTasks(tasks, filter)..sort(_resolveCompare(taskSort)),
          filter: filter,
          taskSort: taskSort,
        );
      },
    );
    return _tasksViewObservable;
  }

  Sink<TasksFilter> get changeTaskFilter => _taskFilterSubject.sink;

  Sink<TaskSort> get changeTaskSort => _taskSortController.sink;

  Sink<TaskCompleted> get taskCompleted => _taskCompletedController.sink;

  Sink<void> get clearCompletedTask => _clearCompletedTasksSubject.sink;

  @override
  void dispose() {
    _taskFilterSubject.close();
    _taskSortController.close();
    _taskCompletedController.close();
    _clearCompletedTasksSubject.close();
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

  void _onTaskSortChanged(TaskSort newTaskSort) {
    Logger.log('onTaskSortChanged(newTaskSort=$newTaskSort})');

    if (newTaskSort != _userSettingsRepository.taskSort.value) {
      _userSettingsRepository.storeTasksSort(newTaskSort);
    }
  }

  void _onTaskCompleted(TaskCompleted toggle) {
    Logger.log(
        '_onTaskCompletedToggled(task=${toggle.id}, completed=${toggle.completed})');

    if (toggle.completed) {
      _taskRepository.completeTask(toggle.id);
    } else {
      _taskRepository.activateTask(toggle.id);
    }
  }

  Future<void> _onClearCompletedTasks(void _) async {
    Logger.log('onClearCompletedTasks()');
    await _taskRepository.clearCompletedTasks();
  }
}

@immutable
class TasksView {
  const TasksView({
    @required this.tasks,
    @required this.filter,
    @required this.taskSort,
  });

  final List<Task> tasks;
  final TasksFilter filter;
  final TaskSort taskSort;
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
