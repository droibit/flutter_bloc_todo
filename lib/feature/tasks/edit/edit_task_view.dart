import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/edit_task_bloc.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/edit_task_bloc_event.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';

class EditTaskView extends StatefulWidget {
  const EditTaskView({Key key}) : super(key: key);

  @override
  State createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  TextEditingController _titleController;

  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    final bloc = EditTaskBlocProvider.of(context);
    final _onEditText = () {
      bloc.events.add(
        EditTaskEvent(
          title: _titleController.text,
          description: _descriptionController.text,
        ),
      );
    };

    _titleController = TextEditingController(
      text: bloc.taskState.value.title,
    );
    _descriptionController = TextEditingController(
      text: bloc.taskState.value.description,
    );

    _titleController.addListener(_onEditText);
    _descriptionController.addListener(_onEditText);
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
