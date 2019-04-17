import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:flutter_bloc_todo/feature/tasks/_common/editable_task_bloc.dart';
import 'package:flutter_bloc_todo/feature/tasks/_common/task_edit.dart';

@immutable
class UpdateTaskBloc extends EditableTaskBloc {
  UpdateTaskBloc({
    @required Task initialTask,
    @required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        _taskId = initialTask.id,
        super(
          initialTaskEdit: TaskEdit(
            title: initialTask.title,
            description: initialTask.description,
          ),
        );

  final TaskRepository _taskRepository;

  final String _taskId;

  @override
  Future<bool> submitTask(TaskEdit taskEdit) {
    return _taskRepository.updateTask(
      _taskId,
      title: taskEdit.title,
      description: taskEdit.description,
    );
  }
}

@immutable
class UpdateTaskBlocProvider extends BlocProvider<UpdateTaskBloc> {
  UpdateTaskBlocProvider({
    @required Task initialTask,
    @required Widget child,
  })  : assert(initialTask != null),
        assert(child != null),
        super(
          creator: (context, _) {
            final deps = DependencyProvider.of(context);
            return UpdateTaskBloc(
              initialTask: initialTask,
              taskRepository: deps.taskRepository,
            );
          },
          child: child,
        );

  static UpdateTaskBloc of(BuildContext context) => BlocProvider.of(context);
}
