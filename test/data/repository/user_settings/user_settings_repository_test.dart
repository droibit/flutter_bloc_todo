import 'package:flutter_bloc_todo/data/repository/user_settings/user_settings_repository.dart';
import 'package:flutter_bloc_todo/data/source/entity/task_sort.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mock.dart';

void main() {
  UserSettingsRepository repository;
  MockLocalSource localSource;

  setUp(() {
    localSource = MockLocalSource();
    repository = UserSettingsRepository(localSource: localSource);
  });

  group('taskSort', () {
    test('should emits loaded TaskSort.', () async {
      const expectTaskSort = TaskSort(
        SortBy.title,
        Order.asc,
      );
      when(localSource.loadTaskSort()).thenReturn(expectTaskSort);

      await expectLater(
        repository.taskSort,
        emits(expectTaskSort),
      );
    });

    test('should emits default TaskSort.', () async {
      when(localSource.loadTaskSort()).thenReturn(null);

      await expectLater(repository.taskSort, emits(defaultTaskSort));
    });
  });

  group('storeTasksSort', () {
    test('should emits new TaskSort when successfully saved.', () async {
      when(localSource.storeTasksSort(any))
          .thenAnswer((_) => Future.value(true));

      const expectTaskSort = TaskSort(
        SortBy.created_date,
        Order.desc,
      );
      final successful = await repository.storeTasksSort(expectTaskSort);
      expect(successful, isTrue);
      expect(repository.taskSort.value, expectTaskSort);
    });

    test('should not emit new TaskSort when failed to save.', () async {
      when(localSource.storeTasksSort(any))
          .thenAnswer((_) => Future.value(false));

      const expectTaskSort = TaskSort(null, null);
      final successful = await repository.storeTasksSort(expectTaskSort);
      expect(successful, isFalse);

      expect(repository.taskSort.value, defaultTaskSort);
    });
  });
}
