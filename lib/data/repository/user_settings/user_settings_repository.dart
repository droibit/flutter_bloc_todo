import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_todo/data/source/source.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';
import 'package:rxdart/rxdart.dart';

@visibleForTesting
const defaultTaskSort = TaskSort(SortBy.title, Order.asc);

class UserSettingsRepository {
  UserSettingsRepository({
    @required LocalSource localSource,
  })  : assert(localSource != null),
        _localSource = localSource;

  final LocalSource _localSource;

  BehaviorSubject<TaskSort> _taskSortSubject;

  ValueObservable<TaskSort> get taskSort {
    _ensureTaskSortSubject(needLoad: true);
    return _taskSortSubject.stream;
  }

  Future<bool> storeTasksSort(TaskSort sort) async {
    final successful = await _localSource.storeTasksSort(sort);
    if (successful) {
      _ensureTaskSortSubject();
      _taskSortSubject.add(sort);
    }
    Logger.log('storeTasksSort(result=$successful');
    return successful;
  }

  void _ensureTaskSortSubject({bool needLoad = false}) {
    _taskSortSubject ??= BehaviorSubject.seeded(
        needLoad ? (_localSource.loadTaskSort() ?? defaultTaskSort) : null);
  }
}
