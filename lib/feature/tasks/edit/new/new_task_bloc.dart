import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/edit_task_bloc_base.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/task_edit_state.dart';

@immutable
class NewTaskBloc extends EditTaskBlocBase {
  NewTaskBloc({
    @required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        super(initialState: const TaskEditState());

  final TaskRepository _taskRepository;

  @override
  Future<bool> submitTask(TaskEditState taskEdit) {
    return _taskRepository.createTask(
      title: taskEdit.title,
      description: taskEdit.description,
    );
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
            return NewTaskBloc(taskRepository: deps.taskRepository);
          },
          child: child,
        );

  static NewTaskBloc of(BuildContext context) => BlocProvider.of(context);
}
