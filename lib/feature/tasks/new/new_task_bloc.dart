import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class TaskEdit {
  const TaskEdit({this.title, this.description = ''});

  final String title;
  final String description;

  bool get isCompleted => title?.isNotEmpty ?? false;
}

class NewTaskBloc extends Bloc {
  NewTaskBloc({
    @required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        _editTaskSubject = BehaviorSubject.seeded(const TaskEdit()),
        _submitTaskController = PublishSubject(),
        _submitResultController = PublishSubject() {
    _submitTaskController.listen(_onSubmitTask);
  }

  final TaskRepository _taskRepository;

  final BehaviorSubject<TaskEdit> _editTaskSubject;

  final PublishSubject<TaskEdit> _submitTaskController;

  final PublishSubject<bool> _submitResultController;

  Observable<bool> get taskEditCompleted {
    return _editTaskSubject.map((editTask) => editTask.isCompleted);
  }

  ValueObservable<TaskEdit> get task => _editTaskSubject.stream;

  Observable<bool> get taskSubmitResult => _submitResultController.stream;

  Sink<TaskEdit> get taskEdit => _editTaskSubject.sink;

  Sink<TaskEdit> get taskSubmit => _submitTaskController.sink;

  @override
  void dispose() {
    _editTaskSubject.close();
    _submitTaskController.close();
  }

  Future<void> _onSubmitTask(TaskEdit taskEdit) async {
    assert(taskEdit.isCompleted);

    // TODO: Prevent double creation.
    final successful = await _taskRepository.createTask(
      title: taskEdit.title,
      description: taskEdit.description,
    );
    _submitResultController.add(successful);
  }
}

@immutable
class NewTaskBlocProvider extends BlocProvider<NewTaskBloc> {
  NewTaskBlocProvider({
    @required Widget child,
  })  : assert(child != null),
        super(
          creator: (context, _) {
            final deps = DependencyProvider.of(context);
            return NewTaskBloc(
              taskRepository: deps.taskRepository,
            );
          },
          child: child,
        );

  static NewTaskBloc of(BuildContext context) => BlocProvider.of(context);
}
