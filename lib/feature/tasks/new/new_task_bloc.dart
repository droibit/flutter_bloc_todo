import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:flutter_bloc_todo/feature/tasks/_common/editable_task_bloc.dart';
import 'package:flutter_bloc_todo/feature/tasks/_common/task_edit.dart';

@immutable
class NewTaskBloc extends EditableTaskBloc {
  NewTaskBloc({
    @required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        super(initialTaskEdit: const TaskEdit());

  final TaskRepository _taskRepository;

  @override
  Future<bool> submitTask(TaskEdit taskEdit) {
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
