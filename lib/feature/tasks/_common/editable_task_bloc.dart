import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_bloc_todo/feature/tasks/_common/task_edit.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class EditableTaskBloc implements Bloc {
  EditableTaskBloc({
    @required TaskEdit initialTaskEdit,
  })  : _editTaskSubject = BehaviorSubject.seeded(initialTaskEdit),
        _submitTaskSubject = PublishSubject(),
        _submitResultSubject = PublishSubject() {
    _submitTaskSubject.map((_) => _editTaskSubject.value).listen(_onSubmitTask);
  }

  final BehaviorSubject<TaskEdit> _editTaskSubject;

  final PublishSubject<void> _submitTaskSubject;

  final PublishSubject<bool> _submitResultSubject;

  Observable<bool> get taskEditCompleted {
    return _editTaskSubject.map((editTask) => editTask.isCompleted).distinct();
  }

  ValueObservable<TaskEdit> get task => _editTaskSubject.stream;

  Observable<bool> get taskSubmitResult => _submitResultSubject.stream;

  Sink<TaskEdit> get taskEdit => _editTaskSubject.sink;

  Sink<void> get taskSubmit => _submitTaskSubject.sink;

  @override
  void dispose() {
    _editTaskSubject.close();
    _submitTaskSubject.close();
  }

  Future<bool> submitTask(TaskEdit taskEdit);

  Future<void> _onSubmitTask(TaskEdit taskEdit) async {
    assert(taskEdit.isCompleted);

    // TODO: Prevent double creation.
    final successful = await submitTask(taskEdit);
    _submitResultSubject.add(successful);
  }
}
