import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc_todo/data/source/source.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';

const _defaultTaskSort = TaskSort(SortBy.title, Order.asc);

class UserSettingsRepository {
  UserSettingsRepository({
    @required LocalSource localSource,
  })  : assert(localSource != null),
        _localSource = localSource,
        _taskSortSubject = BehaviorSubject<TaskSort>() {
    _taskSortSubject.add(_localSource.loadTaskSort() ?? _defaultTaskSort);
  }

  final LocalSource _localSource;

  final BehaviorSubject<TaskSort> _taskSortSubject;

  ValueObservable<TaskSort> get taskSort => _taskSortSubject.stream;

  Future<void> storeTasksSort(TaskSort sort) async {
    final successful = await _localSource.storeTasksSort(sort);
    if (successful) {
      _taskSortSubject.add(sort);
    }
    Logger.log('storeTasksSort(result=$successful');
  }
}
