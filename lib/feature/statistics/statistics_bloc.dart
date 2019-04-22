import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:flutter_bloc_todo/feature/statistics/statistics_state.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class StatisticsBloc implements Bloc {
  const StatisticsBloc({
    @required TaskRepository taskRepository,
  }) : _taskRepository = taskRepository;

  final TaskRepository _taskRepository;

  Observable<StatisticsState> get statisticsState {
    return _taskRepository.tasks
        .map((tasks) => StatisticsState.fromTasks(tasks));
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
