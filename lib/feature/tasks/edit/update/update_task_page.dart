import 'dart:io';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/feature/_widgets/_widgets.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/edit.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/update/update_task_bloc.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/update/update_task_bloc_event.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';
import 'package:flutter_bloc_todo/router/router.dart';

@immutable
class UpdateTaskPage extends StatelessWidget {
  const UpdateTaskPage({
    Key key,
    @required Task initialTask,
  })  : _initialTask = initialTask,
        super(key: key);

  static final route = NamedRoute(
    '/tasks/edit/update',
    (settings) => MaterialPageRoute<bool>(
          builder: (_) =>
              UpdateTaskPage(initialTask: settings.arguments as Task),
          settings: settings,
          fullscreenDialog: true,
        ),
  );

  final Task _initialTask;

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: <BlocProvider>[
        UpdateTaskBlocProvider(
          targetTaskId: _initialTask.id,
        ),
        EditTaskBlocProvider(
          initialState: TaskEditState.fromTask(_initialTask),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          title: Text(S.of(context).editTask),
          centerTitle: Platform.isIOS,
          actions: const <Widget>[
            _UpdateTaskActionButton(),
          ],
        ),
        body: const _UpdateTaskPageBody(),
      ),
    );
  }
}

class _UpdateTaskPageBody extends StatefulWidget {
  const _UpdateTaskPageBody({Key key}) : super(key: key);

  @override
  State createState() => _UpdateTaskPageBodyState();
}

class _UpdateTaskPageBodyState extends State<_UpdateTaskPageBody> {
  @override
  void initState() {
    super.initState();
    final bloc = UpdateTaskBlocProvider.of(context);
    bloc.updateTaskResult.listen((successful) {
      Navigator.pop(context, successful);
    });
  }

  @override
  Widget build(BuildContext context) => const EditTaskView();
}

@immutable
class _UpdateTaskActionButton extends StatelessWidget {
  const _UpdateTaskActionButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editTaskBloc = EditTaskBlocProvider.of(context);
    return StreamBuilder<TaskEditState>(
      stream: editTaskBloc.taskState,
      builder: (_context, snapshot) {
        final state = snapshot.data;
        return IconButton(
          icon: const Icon(Icons.done),
          onPressed: () {
            if (state.isCompleted) {
              final updateTaskBloc = UpdateTaskBlocProvider.of(_context);
              updateTaskBloc.events.add(
                UpdateTaskEvent(
                  title: state.title,
                  description: state.description,
                ),
              );
            } else {
              showShortToast(
                msg: S.of(context).editTaskEmptyTitleError,
              );
            }
          },
        );
      },
    );
  }
}
