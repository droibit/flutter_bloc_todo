import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/editable_task_bloc.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/task_edit.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';

typedef EditableTaskBlocProvider = EditableTaskBloc Function(
    BuildContext context);

class EditTaskBody extends StatefulWidget {
  const EditTaskBody({
    Key key,
    @required EditableTaskBlocProvider blocProvider,
  })  : _blocProvider = blocProvider,
        super(key: key);

  final EditableTaskBlocProvider _blocProvider;

  @override
  State createState() => _EditTaskBodyState();
}

class _EditTaskBodyState extends State<EditTaskBody> {
  TextEditingController _titleController;

  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    final bloc = widget._blocProvider(context);
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
