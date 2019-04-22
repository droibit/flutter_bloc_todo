import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/edit_task_bloc_base.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/task_edit_state.dart';

@immutable
class UpdateTaskBloc extends EditTaskBlocBase {
  UpdateTaskBloc({
    @required Task initialTask,
    @required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        _taskId = initialTask.id,
        super(
          initialState: TaskEditState(
            title: initialTask.title,
            description: initialTask.description,
          ),
        );

  final TaskRepository _taskRepository;

  final String _taskId;

  @override
  Future<bool> submitTask(TaskEditState taskEdit) {
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
