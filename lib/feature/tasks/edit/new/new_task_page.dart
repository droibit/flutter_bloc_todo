import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/feature/_widgets/_widgets.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/edit.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/new/new_task_bloc.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/new/new_task_bloc_event.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';
import 'package:flutter_bloc_todo/router/router.dart';

class NewTaskPage extends StatelessWidget {
  static final route = NamedRoute(
    '/tasks/edit/new',
    (settings) => MaterialPageRoute<bool>(
          builder: (_) => NewTaskPage(),
          settings: settings,
          fullscreenDialog: true,
        ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: <BlocProvider>[
        EditTaskBlocProvider(
          initialState: const TaskEditState(),
        ),
        NewTaskBlocProvider(),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          title: Text(S.of(context).newTask),
          actions: const <Widget>[
            _CreateTaskActionButton(),
          ],
        ),
        body: const _NewTaskPageBody(),
      ),
    );
  }
}

class _NewTaskPageBody extends StatefulWidget {
  const _NewTaskPageBody({Key key}) : super(key: key);

  @override
  State createState() => _NewTaskPageBodyState();
}

class _NewTaskPageBodyState extends State<_NewTaskPageBody> {
  @override
  void initState() {
    super.initState();
    final bloc = NewTaskBlocProvider.of(context);
    bloc.createTaskResult.listen((successful) {
      Navigator.pop(context, successful);
    });
  }

  @override
  Widget build(BuildContext context) => const EditTaskView();
}

@immutable
class _CreateTaskActionButton extends StatelessWidget {
  const _CreateTaskActionButton({Key key}) : super(key: key);

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
              final newTaskBloc = NewTaskBlocProvider.of(_context);
              newTaskBloc.events.add(
                CreateTaskEvent(
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
