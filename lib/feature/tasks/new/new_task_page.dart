import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/feature/_widgets/_widgets.dart';
import 'package:flutter_bloc_todo/feature/router/router.dart';
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
          leading: const BackIconButton(),
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
  TextEditingController _titleController;

  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    final bloc = NewTaskBlocProvider.of(context);
    final _onEditText = () {
      bloc.taskEdit.add(
        TaskEdit(
          title: _titleController.text,
          description: _descriptionController.text,
        ),
      );
    };

    _titleController = TextEditingController(
      text: bloc.task.value.title,
    );
    _descriptionController = TextEditingController(
      text: bloc.task.value.description,
    );

    _titleController.addListener(_onEditText);
    _descriptionController.addListener(_onEditText);

    bloc.taskSubmitResult.listen(_onHandleTaskSubmitResult);
  }

  void _onHandleTaskSubmitResult(bool successful) {
    Navigator.pop(context, successful);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: strings.editTaskTitleLabel,
            ),
            maxLines: 1,
            maxLength: 60,
          ),
          const SizedBox(height: 24.0),
          Text(
            strings.editTaskDescLabel,
            textAlign: TextAlign.start,
            style: theme.textTheme.caption.copyWith(
              color: theme.primaryColor,
            ),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(hintText: strings.editTaskDescHint),
            keyboardType: TextInputType.multiline,
            maxLines: 10,
            maxLength: 500,
          ),
        ],
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
          onPressed: (editCompleted ?? false)
              ? () => _onDoneButtonPressed(bloc)
              : null,
        );
      },
    );
  }

  void _onDoneButtonPressed(NewTaskBloc bloc) {
    bloc.taskSubmit.add(null);
  }
}
