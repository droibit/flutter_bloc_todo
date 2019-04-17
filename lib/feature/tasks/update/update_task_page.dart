import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/feature/_widgets/_widgets.dart';
import 'package:flutter_bloc_todo/feature/router/router.dart';
import 'package:flutter_bloc_todo/feature/tasks/_common/edit_task_body.dart';
import 'package:flutter_bloc_todo/feature/tasks/update/update_task_bloc.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';

@immutable
class UpdateTaskPage extends StatelessWidget {
  const UpdateTaskPage({
    Key key,
    @required Task initialTask,
  })  : _initialTask = initialTask,
        super(key: key);

  static final route = NamedRoute(
    '/tasks/update',
    (settings) => MaterialPageRoute<bool>(
          builder: (_) {
            return UpdateTaskPage(
              // ignore: avoid_as
              initialTask: settings.arguments as Task,
            );
          },
          settings: settings,
          fullscreenDialog: true,
        ),
  );

  final Task _initialTask;

  @override
  Widget build(BuildContext context) {
    return UpdateTaskBlocProvider(
      initialTask: _initialTask,
      child: Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          title: Text(S.of(context).editTask),
          centerTitle: Platform.isIOS,
          actions: const <Widget>[
            _UpdateTaskActionButton(),
          ],
        ),
        body: const EditTaskBody(
          blocProvider: UpdateTaskBlocProvider.of,
        ),
      ),
    );
  }
}

@immutable
class _UpdateTaskActionButton extends StatelessWidget {
  const _UpdateTaskActionButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = UpdateTaskBlocProvider.of(context);
    return StreamBuilder<bool>(
      stream: bloc.taskEditCompleted,
      builder: (_context, snapshot) {
        final editCompleted = snapshot.data;
        return IconButton(
          icon: const Icon(Icons.done),
          onPressed: () {
            if (editCompleted ?? false) {
              bloc.taskSubmit.add(null);
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

