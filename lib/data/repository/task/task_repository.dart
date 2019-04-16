import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_todo/data/source/source.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class TaskRepository {
  TaskRepository({
    @required LocalSource localSource,
  })  : assert(localSource != null),
        _localSource = localSource,
        _uuid = Uuid();

  final LocalSource _localSource;

  final Uuid _uuid;

  BehaviorSubject<List<Task>> _tasksSubject;

  ValueObservable<List<Task>> get tasks {
    _ensureTasksSubject(needLoad: true);
    return _tasksSubject.stream;
  }

  Future<bool> createTask({
    @required String title,
    String description,
  }) async {
    assert(title != null);

    final tasks = _localSource.loadTasks();
    final newTask = Task(
      id: _uuid.v4(),
      title: title,
      description: description ?? '',
      timestamp: DateTime.now(),
    );
    tasks.add(newTask);

    final successful = await _localSource.storeTasks(tasks);
    if (successful) {
      _ensureTasksSubject();
      _tasksSubject.add(List.unmodifiable(tasks));
    }
    return successful;
  }

  Future<bool> updateTask(
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

  Future<bool> activateTask(
    String taskId,
  ) {
    return _updateTask(taskId, (oldTask) => oldTask.copyWith(completed: false));
  }

  Future<bool> completeTask(String taskId) {
    return _updateTask(taskId, (oldTask) => oldTask.copyWith(completed: true));
  }

  Future<bool> deleteTask(String taskId) {
    return _updateTask(taskId, (oldTask) => null);
  }

  Future<bool> clearCompletedTasks() async {
    final tasks = _localSource.loadTasks();
    final oldTaskCount = tasks.length;
    tasks.removeWhere((task) => task.completed);

    if (oldTaskCount != tasks.length) {
      return await _storeNewTasks(tasks);
    }
    return true;
  }

  Future<bool> _updateTask(String taskId, Task map(Task oldTask)) {
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

  Future<bool> _storeNewTasks(List<Task> newTasks) async {
    final successful = await _localSource.storeTasks(newTasks);
    if (successful) {
      _ensureTasksSubject();
      _tasksSubject.add(List.unmodifiable(newTasks));
    }
    return successful;
  }
}
