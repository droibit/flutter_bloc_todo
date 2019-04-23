import 'dart:async';

import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/feature/tasks/tasks_bloc.dart';
import 'package:flutter_bloc_todo/feature/tasks/tasks_bloc_event.dart';
import 'package:flutter_bloc_todo/feature/tasks/tasks_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import '../../mock.dart';

void main() {
  MockTaskRepository taskRepository;
  MockUserSettingsRepository userSettingsRepository;
  BehaviorSubject<TasksFilter> taskFilterSubject;
  TasksBloc bloc;

  setUp(() {
    taskRepository = MockTaskRepository();
    userSettingsRepository = MockUserSettingsRepository();
    taskFilterSubject = BehaviorSubject.seeded(TasksFilter.all);
    bloc = TasksBloc(
      taskRepository: taskRepository,
      userSettingsRepository: userSettingsRepository,
      taskFilterSubject: taskFilterSubject,
    );
  });

  group('onHandleEvent', () {
    test('handle ChangeTasksFilterEvent', () async {
      const expectEvent = ChangeTasksFilterEvent(TasksFilter.active);

      expectLater(
        taskFilterSubject,
        emitsInAnyOrder(
          <TasksFilter>[TasksFilter.all, expectEvent.filter],
        ),
      );

      bloc.onHandleEvent(expectEvent);
    });

    test('handle same ChangeTaskSortEvent', () {
      const expectTaskSort = TaskSort(SortBy.title, Order.asc);
      when(userSettingsRepository.taskSort).thenAnswer(
        (_) => BehaviorSubject.seeded(expectTaskSort),
      );

      const expectEvent = ChangeTaskSortEvent(expectTaskSort);
      bloc.onHandleEvent(expectEvent);

      verifyNever(userSettingsRepository.storeTasksSort(any));
    });

    test('handle changed ChangeTaskSortEvent', () {
      const oldTaskSort = TaskSort(SortBy.title, Order.desc);
      when(userSettingsRepository.taskSort).thenAnswer(
        (_) => BehaviorSubject.seeded(oldTaskSort),
      );

      const expectTaskSort = TaskSort(SortBy.title, Order.asc);
      const expectEvent = ChangeTaskSortEvent(expectTaskSort);
      bloc.onHandleEvent(expectEvent);

      verify(userSettingsRepository.storeTasksSort(expectTaskSort));
    });

    // TODO: other test code that handling rest events.
  });

  group('tasksState', () {
    test('emit taskState', () async {
      final expectActiveTask = Task(
        id: '1',
        title: 'TODO-1',
        completed: false,
        timestamp: DateTime.now(),
      );
      final expectCompletedTask = Task(
        id: '2',
        title: 'TODO-2',
        completed: true,
        timestamp: DateTime.now(),
      );

      final expectTasks = <Task>[
        expectActiveTask,
        expectCompletedTask,
      ];
      final expectTasksSubject = BehaviorSubject<List<Task>>.seeded(
        expectTasks,
      );
      const expectTaskSort = TaskSort(SortBy.created_date, Order.asc);
      final expectTaskSortSubject = BehaviorSubject.seeded(expectTaskSort);

      when(taskRepository.tasks).thenAnswer((_) => expectTasksSubject);
      when(userSettingsRepository.taskSort).thenAnswer(
        (_) => expectTaskSortSubject,
      );

      expectLater(
        bloc.tasksState,
        emitsInAnyOrder(<TasksState>[
          TasksState(
            tasks: <Task>[
              expectActiveTask,
              expectCompletedTask,
            ],
            filter: TasksFilter.all,
            taskSort: expectTaskSort,
          ),
          TasksState(
            tasks: <Task>[
              expectCompletedTask,
              expectActiveTask,
            ],
            filter: TasksFilter.all,
            taskSort: expectTaskSort.reverseOrder(),
          ),
          TasksState(
            tasks: <Task>[expectActiveTask],
            filter: TasksFilter.active,
            taskSort: expectTaskSort.reverseOrder(),
          ),
        ]),
      );

      expectTaskSortSubject.add(expectTaskSort.reverseOrder());
      taskFilterSubject.add(TasksFilter.active);
    });
  });
}
