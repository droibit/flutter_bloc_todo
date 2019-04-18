import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class StatisticsView {
  const StatisticsView({
    this.activeCount,
    this.completedCount,
  });

  factory StatisticsView.fromTasks(List<Task> tasks) {
    final activeCount = tasks.where((task) => task.isActive).length;
    return StatisticsView(
      activeCount: activeCount,
      completedCount: tasks.length - activeCount,
    );
  }

  final int activeCount;
  final int completedCount;

  bool get hasNotTask => activeCount == 0 && completedCount == 0;
}

@immutable
class StatisticsBloc implements Bloc {
  const StatisticsBloc({
    @required TaskRepository taskRepository,
  }) : _taskRepository = taskRepository;

  final TaskRepository _taskRepository;

  Observable<StatisticsView> get statisticsView {
    return _taskRepository.tasks
        .map((tasks) => StatisticsView.fromTasks(tasks));
  }

  @override
  void dispose() {}
}

@immutable
class StatisticsBlocProvider extends BlocProvider<StatisticsBloc> {
  StatisticsBlocProvider({
    @required Widget child,
  })  : assert(child != null),
        super(
          creator: (context, _) {
            final deps = DependencyProvider.of(context);
            return StatisticsBloc(
              taskRepository: deps.taskRepository,
            );
          },
          child: child,
        );

  static StatisticsBloc of(BuildContext context) => BlocProvider.of(context);
}
