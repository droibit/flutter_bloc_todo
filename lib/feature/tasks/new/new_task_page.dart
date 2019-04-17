import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/feature/_widgets/_widgets.dart';
import 'package:flutter_bloc_todo/feature/router/router.dart';
import 'package:flutter_bloc_todo/feature/tasks/_common/edit_task_body.dart';
import 'package:flutter_bloc_todo/feature/tasks/new/new_task_bloc.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';

class NewTaskPage extends StatelessWidget {
  static final route = NamedRoute(
    '/tasks/new',
    (settings) => MaterialPageRoute<bool>(
          builder: (_) => NewTaskPage(),
          settings: settings,
          fullscreenDialog: true,
        ),
  );

  @override
  Widget build(BuildContext context) {
    return NewTaskBlocProvider(
      child: Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          title: Text(S.of(context).newTask),
          actions: const <Widget>[
            _CreateTaskActionButton(),
          ],
        ),
        body: EditTaskBody(
          blocProvider: (_context) => NewTaskBlocProvider.of(_context),
        ),
      ),
    );
  }
}

@immutable
class _CreateTaskActionButton extends StatelessWidget {
  const _CreateTaskActionButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = NewTaskBlocProvider.of(context);
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
