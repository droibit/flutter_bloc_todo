import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:flutter_bloc_todo/feature/bloc_base.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/update/update_task_bloc_event.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class UpdateTaskBloc extends SimpleBlocBase {
  @visibleForTesting
  UpdateTaskBloc({
    @required String targetTaskId,
    @required TaskRepository taskRepository,
    @required PublishSubject<bool> updateResultSubject,
  })  : _targetTaskId = targetTaskId,
        _taskRepository = taskRepository,
        _updateResultSubject = updateResultSubject;

  factory UpdateTaskBloc._({
    @required String targetTaskId,
    @required TaskRepository taskRepository,
  }) {
    return UpdateTaskBloc(
      targetTaskId: targetTaskId,
      taskRepository: taskRepository,
      updateResultSubject: PublishSubject(),
    );
  }

  final String _targetTaskId;

  final TaskRepository _taskRepository;

  final PublishSubject<bool> _updateResultSubject;

  Observable<bool> get updateTaskResult => _updateResultSubject.stream;

  @override
  void onHandleEvent(BlocEvent event) {
    if (event is UpdateTaskEvent) {
      _onUpdateTaskEvent(event);
    } else {
      throw ArgumentError('Unknown event: ${event.runtimeType}');
    }
  }

  Future<void> _onUpdateTaskEvent(UpdateTaskEvent event) async {
    Logger.log('onUpdateTaskEvent($event)');

    // TODO: Prevent double creation.
    final successful = await _taskRepository.updateTask(
      _targetTaskId,
      title: event.title,
      description: event.description,
    );
    _updateResultSubject.add(successful);
  }
}

@immutable
class UpdateTaskBlocProvider extends BlocProvider<UpdateTaskBloc> {
  UpdateTaskBlocProvider({
    @required String targetTaskId,
    Widget child,
  })  : assert(targetTaskId != null),
        super(
          creator: (context, _) {
            final deps = DependencyProvider.of(context);
            return UpdateTaskBloc._(
              targetTaskId: targetTaskId,
              taskRepository: deps.taskRepository,
            );
          },
          child: child,
        );

  static UpdateTaskBloc of(BuildContext context) => BlocProvider.of(context);
}
