import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:flutter_bloc_todo/feature/tasks/_common/task_completed.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class TaskDetailBloc implements Bloc {
  TaskDetailBloc({
    @required Task initialTask,
    @required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        _taskId = initialTask.id,
        _taskSubject = BehaviorSubject.seeded(initialTask),
        _taskCompletedSubject = PublishSubject() {
    _taskCompletedSubject.listen(_onTaskCompleted);
    _taskRepository.tasks
        .map(
          (tasks) => tasks.firstWhere((task) => task.id == _taskId),
        )
        .pipe(_taskSubject);
  }

  final TaskRepository _taskRepository;

  final BehaviorSubject<Task> _taskSubject;

  final PublishSubject<TaskCompleted> _taskCompletedSubject;

  final String _taskId;

  ValueObservable<Task> get task => _taskSubject.stream;

  Sink<TaskCompleted> get taskCompleted => _taskCompletedSubject.sink;

  @override
  void dispose() {}

  void _onTaskCompleted(TaskCompleted toggle) {
    Logger.log(
        '_onTaskCompletedToggled(task=${toggle.id}, completed=${toggle.completed})');

    if (toggle.completed) {
      _taskRepository.completeTask(toggle.id);
    } else {
      _taskRepository.activateTask(toggle.id);
    }
  }
}

@immutable
class TaskDetailBlocProvider extends BlocProvider<TaskDetailBloc> {
  TaskDetailBlocProvider({
    @required Task initialTask,
    @required Widget child,
  })  : assert(initialTask != null),
        assert(child != null),
        super(
          creator: (context, _) {
            final deps = DependencyProvider.of(context);
            return TaskDetailBloc(
              initialTask: initialTask,
              taskRepository: deps.taskRepository,
            );
          },
          child: child,
        );

  static TaskDetailBloc of(BuildContext context) => BlocProvider.of(context);
}
