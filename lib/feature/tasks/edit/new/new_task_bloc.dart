import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:flutter_bloc_todo/feature/bloc_base.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/new/new_task_bloc_event.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class NewTaskBloc extends SimpleBlocBase {
  @visibleForTesting
  NewTaskBloc({
    @required TaskRepository taskRepository,
    @required PublishSubject<bool> createResultSubject,
  })  : _taskRepository = taskRepository,
        _createResultSubject = createResultSubject;

  factory NewTaskBloc._({
    @required TaskRepository taskRepository,
  }) {
    return NewTaskBloc(
      taskRepository: taskRepository,
      createResultSubject: PublishSubject(),
    );
  }

  final TaskRepository _taskRepository;

  final PublishSubject<bool> _createResultSubject;

  Observable<bool> get createTaskResult => _createResultSubject.stream;

  @override
  void onHandleEvent(BlocEvent event) {
    if (event is CreateTaskEvent) {
      _onCreateTaskEvent(event);
    } else {
      throw ArgumentError('Unknown event: ${event.runtimeType}');
    }
  }

  Future<void> _onCreateTaskEvent(CreateTaskEvent event) async {
    Logger.log('onCreateTaskEvent($event)');

    // TODO: Prevent double creation.
    final successful = await _taskRepository.createTask(
      title: event.title,
      description: event.description,
    );
    _createResultSubject.add(successful);
  }
}

@immutable
class NewTaskBlocProvider extends BlocProvider<NewTaskBloc> {
  NewTaskBlocProvider({
    Widget child,
  }) : super(
          creator: (context, _) {
            final deps = DependencyProvider.of(context);
            return NewTaskBloc._(
              taskRepository: deps.taskRepository,
            );
          },
          child: child,
        );

  static NewTaskBloc of(BuildContext context) => BlocProvider.of(context);
}
