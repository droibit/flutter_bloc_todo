import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_todo/feature/bloc_base.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/edit_task_bloc_event.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/task_edit_state.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

abstract class EditTaskBlocBase extends SimpleBlocBase {
  EditTaskBlocBase({
    @required TaskEditState initialState,
  })  : _editTaskSubject = BehaviorSubject.seeded(initialState),
        _submitResultSubject = PublishSubject();

  final BehaviorSubject<TaskEditState> _editTaskSubject;

  final PublishSubject<bool> _submitResultSubject;

  Observable<bool> get taskEditCompleted {
    return _editTaskSubject.map((editTask) => editTask.isCompleted).distinct();
  }

  ValueObservable<TaskEditState> get taskState => _editTaskSubject.stream;

  Observable<bool> get taskSubmitResult => _submitResultSubject.stream;

  Future<bool> submitTask(TaskEditState taskEdit);

  @override
  void onHandleEvent(BlocEvent event) {
    if (event is EditTaskEvent) {
      _onEditTaskEvent(event);
    } else if (event is SubmitTaskEvent) {
      _onSubmitTaskEvent(event);
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

  Future<void> _onSubmitTaskEvent(SubmitTaskEvent event) async {
    Logger.log('onSubmitTaskEvent()');

    final taskEdit = _editTaskSubject.value;
    assert(taskEdit != null);

    // TODO: Prevent double creation.
    final successful = await submitTask(taskEdit);
    _submitResultSubject.add(successful);
  }

  @override
  void dispose() {
    _editTaskSubject.close();
    _submitResultSubject.close();
    super.dispose();
  }
}
