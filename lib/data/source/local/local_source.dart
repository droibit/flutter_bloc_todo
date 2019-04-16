import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_todo/data/source/entity/task.dart';
import 'package:flutter_bloc_todo/data/source/entity/task_sort.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _KEY_TASK_SORT = 'task_sort';
const _KEY_TASKS = 'tasks';

class LocalSource {
  LocalSource({@required SharedPreferences sharedPrefs})
      : assert(sharedPrefs != null),
        _sharedPrefs = sharedPrefs;

  final SharedPreferences _sharedPrefs;

  List<Task> loadTasks() {
    final json = _sharedPrefs.getString(_KEY_TASKS);
    if (json == null) {
      return [];
    }
    // ignore: avoid_as
    return (jsonDecode(json) as List<dynamic>)
        .map((dynamic taskJson) => Task.fromJson(taskJson))
        .toList();
  }

  Future<bool> storeTasks(List<Task> tasks) {
    final json = jsonEncode(tasks);
    return _sharedPrefs.setString(_KEY_TASKS, json);
  }

  TaskSort loadTaskSort() {
    final json = _sharedPrefs.getString(_KEY_TASK_SORT);
    if (json == null) {
      return null;
    }
    return TaskSort.fromMap(jsonDecode(json));
  }

  Future<bool> storeTasksSort(TaskSort sort) async {
    final json = jsonEncode(sort.toJson());
    return _sharedPrefs.setString(_KEY_TASK_SORT, json);
  }
}
