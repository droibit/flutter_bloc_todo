import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:flutter_bloc_todo/feature/bloc_base.dart';
import 'package:flutter_bloc_todo/feature/tasks/detail/task_detail_bloc_event.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class TaskDetailBloc extends SimpleBlocBase {
  @visibleForTesting
  TaskDetailBloc({
    @required TaskRepository taskRepository,
    @required BehaviorSubject<Task> taskSubject,
    @required CompositeSubscription subscriptions,
  })  : _taskRepository = taskRepository,
        _taskSubject = taskSubject,
        _subscriptions = subscriptions {
    final initialTaskId = _taskSubject.value.id;
    _subscriptions.add(
      _taskRepository.tasks
          .map((tasks) => tasks.firstWhere((task) => task.id == initialTaskId))
          .listen((task) => _taskSubject.add(task)),
    );
  }

  factory TaskDetailBloc._({
    @required Task initialTask,
    @required TaskRepository taskRepository,
  }) {
    return TaskDetailBloc(
      taskRepository: taskRepository,
      taskSubject: BehaviorSubject.seeded(initialTask),
      subscriptions: CompositeSubscription(),
    );
  }

  final TaskRepository _taskRepository;

  final BehaviorSubject<Task> _taskSubject;

  final CompositeSubscription _subscriptions;

  ValueObservable<Task> get task => _taskSubject;

  @override
  void onHandleEvent(BlocEvent event) {
    if (event is ChangeTaskCompletedEvent) {
      _onChangeTaskCompletedEvent(event);
    } else {
      throw ArgumentError('Unknown event: ${event.runtimeType}');
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

  @override
  void dispose() {
    _subscriptions.dispose();
    _taskSubject.close();
    super.dispose();
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
            return TaskDetailBloc._(
              initialTask: initialTask,
              taskRepository: deps.taskRepository,
            );
          },
          child: child,
        );

  static TaskDetailBloc of(BuildContext context) => BlocProvider.of(context);
}
