import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_todo/data/source/source.dart';
import 'package:rxdart/rxdart.dart';

class TaskRepository {
  TaskRepository({
    @required LocalSource localSource,
  })  : assert(localSource != null),
        _localSource = localSource;

  final LocalSource _localSource;

  BehaviorSubject<List<Task>> _tasksSubject;

  ValueObservable<List<Task>> get tasks {
    _ensureTasksSubject(needLoad: true);
    return _tasksSubject.stream;
  }

  Future<void> updateTask(
    String taskId, {
    String title,
    String description,
  }) {
    assert(title != null || description != null);
    return _updateTask(
      taskId,
      (oldTask) => oldTask.copyWith(
            title: title,
            description: description,
          ),
    );
  }

  Future<void> activateTask(
    String taskId,
  ) {
    return _updateTask(taskId, (oldTask) => oldTask.copyWith(completed: false));
  }

  Future<void> completeTask(String taskId) {
    return _updateTask(taskId, (oldTask) => oldTask.copyWith(completed: true));
  }

  Future<void> deleteTask(String taskId) {
    return _updateTask(taskId, (oldTask) => null);
  }

  Future<void> clearCompletedTasks() async {
    final tasks = _localSource.loadTasks();
    final oldTaskCount = tasks.length;
    tasks.removeWhere((task) => task.completed);

    if (oldTaskCount != tasks.length) {
      await _storeNewTasks(tasks);
    }
  }

  Future<void> _updateTask(String taskId, Task map(Task oldTask)) {
    final List<Task> tasks = _localSource.loadTasks();
    final index = tasks.indexWhere((task) => task.id == taskId);
    assert(index != -1);

    final newTask = map(tasks[index]);
    if (newTask == null) {
      tasks.removeAt(index);
    } else {
      tasks[index] = newTask;
    }
    return _storeNewTasks(tasks);
  }

  void _ensureTasksSubject({bool needLoad = false}) {
    _tasksSubject ??= BehaviorSubject.seeded(
      needLoad ? _localSource.loadTasks() : [],
    );
  }

  Future<void> _storeNewTasks(List<Task> newTasks) async {
    final successful = await _localSource.storeTasks(newTasks);
    if (successful) {
      _ensureTasksSubject();
      _tasksSubject.add(List.unmodifiable(newTasks));
    }
  }
}
