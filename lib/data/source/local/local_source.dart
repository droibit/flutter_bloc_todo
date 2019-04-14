import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_bloc_todo/data/source/entity/task.dart';
import 'package:flutter_bloc_todo/data/source/entity/task_sort.dart';

const _KEY_TASK_SORT = 'task_sort';

class LocalSource {
  LocalSource({@required SharedPreferences sharedPrefs})
      : assert(sharedPrefs != null),
        _sharedPrefs = sharedPrefs;

  final SharedPreferences _sharedPrefs;

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
