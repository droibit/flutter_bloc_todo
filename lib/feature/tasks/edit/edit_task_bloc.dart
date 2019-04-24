import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/feature/bloc_base.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/edit_task_bloc_event.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/task_edit_state.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class EditTaskBloc extends SimpleBlocBase {
  @visibleForTesting
  EditTaskBloc({
    @required BehaviorSubject<TaskEditState> editTaskSubject,
  }) : _editTaskSubject = editTaskSubject;

  factory EditTaskBloc._({
    @required TaskEditState initialState,
  }) {
    return EditTaskBloc(
      editTaskSubject: BehaviorSubject.seeded(initialState),
    );
  }

  final BehaviorSubject<TaskEditState> _editTaskSubject;

  ValueObservable<TaskEditState> get taskState => _editTaskSubject.stream;

  @override
  void onHandleEvent(BlocEvent event) {
    if (event is EditTaskEvent) {
      _onEditTaskEvent(event);
    } else {
      throw ArgumentError('Unknown event: ${event.runtimeType}');
    }
  }

  void _onEditTaskEvent(EditTaskEvent event) {
    Logger.log(
        'onEditTaskEvent(title=${event.title}, desc=${event.description})');
    _editTaskSubject.add(
      TaskEditState(title: event.title, description: event.description),
    );
  }

  @override
  void dispose() {
    _editTaskSubject.close();
    super.dispose();
  }
}

@immutable
class EditTaskBlocProvider extends BlocProvider<EditTaskBloc> {
  EditTaskBlocProvider({
    @required TaskEditState initialState,
    Widget child,
  })  : assert(initialState != null),
        super(
          creator: (context, _) => EditTaskBloc._(initialState: initialState),
          child: child,
        );

  static EditTaskBloc of(BuildContext context) => BlocProvider.of(context);
}
