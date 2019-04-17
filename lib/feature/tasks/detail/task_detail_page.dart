import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/feature/router/router.dart';
import 'package:flutter_bloc_todo/feature/tasks/_common/task_completed.dart';
import 'package:flutter_bloc_todo/feature/tasks/detail/task_detail_bloc.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

@immutable
class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({
    Key key,
    @required Task initialTask,
  })  : _initialTask = initialTask,
        super(key: key);

  final Task _initialTask;

  static final route = NamedRoute(
    '/tasks/detail',
    (settings) => MaterialPageRoute<void>(
          builder: (_) {
            return TaskDetailPage(
              // ignore: avoid_as
              initialTask: settings.arguments as Task,
            );
          },
          settings: settings,
        ),
  );

  @override
  Widget build(BuildContext context) {
    return TaskDetailBlocProvider(
      initialTask: _initialTask,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: Text(S.of(context).appName),
          centerTitle: Platform.isIOS,
        ),
        body: const _TaskDetailPageBody(),
        floatingActionButton: const _EditTaskButton(),
      ),
    );
  }
}

@immutable
class _TaskDetailPageBody extends StatelessWidget {
  const _TaskDetailPageBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = TaskDetailBlocProvider.of(context);
    return StreamBuilder<Task>(
      initialData: bloc.task.value,
      stream: bloc.task,
      builder: (_context, snapshot) {
        assert(snapshot.data != null);

        final task = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[]
                ..add(_buildTitleAndDescSection(context, task))
                ..add(_buildTimestampSection(context, task)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleAndDescSection(BuildContext context, Task task) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Checkbox(
        value: task.completed,
        onChanged: (checked) => _onTaskChecked(context, task, checked),
      ),
      title: Text(
        task.title,
        style: theme.textTheme.title,
      ),
      subtitle: task.hasDescription
          ? Text(
              task.description,
              style: theme.textTheme.subhead,
            )
          : null,
    );
  }

  void _onTaskChecked(BuildContext context, Task task, bool completed) {
    final bloc = TaskDetailBlocProvider.of(context);
    bloc.taskCompleted.add(
      TaskCompleted(id: task.id, completed: completed),
    );
  }

  Widget _buildTimestampSection(BuildContext context, Task task) {
    return ListTile(
      leading: SizedBox.fromSize(
        size: const Size.square(52.0),
        child: const Icon(Icons.calendar_today),
      ),
      title: Text(
        DateFormat.yMMMMd().format(task.timestamp),
        style: Theme.of(context).textTheme.subtitle,
      ),
    );
  }
}

@immutable
class _EditTaskButton extends StatelessWidget {
  const _EditTaskButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.edit),
      onPressed: () => _navigateToNewTask(context),
    );
  }

  Future<void> _navigateToNewTask(BuildContext context) async {
//    final bool successful =
//    await Navigator.pushNamed(context, NewTaskPage.route.name);
//
//    if (successful == null) {
//      return;
//    }
//
//    final strings = S.of(context);
//    _showSnackBar(
//      context,
//      message: successful
//          ? strings.newTaskSuccessfulToCreate
//          : strings.newTaskFailedToCreate,
//    );
  }
}
