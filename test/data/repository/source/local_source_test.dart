import 'package:flutter/services.dart';
import 'package:flutter_bloc_todo/data/source/entity/task.dart';
import 'package:flutter_bloc_todo/data/source/entity/task_sort.dart';
import 'package:flutter_bloc_todo/data/source/local/local_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{}; // set initial values here if desired
    }
    return null;
  });

  LocalSource source;
  SharedPreferences sharedPrefs;

  setUp(() async {
    sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.clear();

    source = LocalSource(sharedPrefs: sharedPrefs);
  });

  group('loadTasks', () {
    test('should return empty list if has not been saved.', () {
      expect(source.loadTasks(), isEmpty);
    });

    test('should return task list if saved.', () async {
      const srcJson =
          '[{"id":"1","title":"TODO-1","description":"","timestamp":"2019-04-18T00:00:00+09:00","completed":false},{"id":"2","title":"タスク-2","description":"test_description","timestamp":"2019-04-19T00:00:00+09:00","completed":true}]';
      await sharedPrefs.setString(KEY_TASKS, srcJson);

      expect(
        source.loadTasks(),
        <Task>[
          Task(
            id: '1',
            title: 'TODO-1',
            description: '',
            timestamp: DateTime.parse('2019-04-18T00:00:00+09:00'),
            completed: false,
          ),
          Task(
            id: '2',
            title: 'タスク-2',
            description: 'test_description',
            timestamp: DateTime.parse('2019-04-19T00:00:00+09:00'),
            completed: true,
          ),
        ],
      );
    });
  });

  group('storeTasks', () {
    test('should save tasks as json.', () async {
      await source.storeTasks(const <Task>[]);

      expect(sharedPrefs.get(KEY_TASKS), isNotEmpty);
    });
  });

  group('loadTaskSort', () {
    test('should return null if has not been saved.', () async {
      expect(source.loadTaskSort(), isNull);
    });

    test('should return TaskSort if saved.', () async {
      const srcJson = '{"by":"title","order":"asc"}';
      await sharedPrefs.setString(KEY_TASK_SORT, srcJson);

      expect(source.loadTaskSort(), const TaskSort(SortBy.title, Order.asc));
    });
  });

  group('storeTasksSort', () {
    test('should save TaskSort as json.', () async {
      await source.storeTasksSort(
        const TaskSort(SortBy.created_date, Order.desc),
      );

      expect(sharedPrefs.getString(KEY_TASK_SORT), isNotEmpty);
    });
  });
}
