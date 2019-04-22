import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/feature/_widgets/_widgets.dart';
import 'package:flutter_bloc_todo/feature/statistics/statistics_bloc.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';
import 'package:flutter_bloc_todo/router/router.dart';

@immutable
class StatisticsPage extends StatelessWidget {
  static final route = NamedRoute(
    '/statistics',
    (settings) => FadePageRoute<void>(
          builder: (_) => StatisticsPage(),
          settings: settings,
        ),
  );

  @override
  Widget build(BuildContext context) {
    return StatisticsBlocProvider(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).statistics),
        ),
        drawer: const AppDrawer(selectedNavItem: DrawerNavigation.statistics),
        body: const _StatisticsPageBody(),
      ),
    );
  }
}

@immutable
class _StatisticsPageBody extends StatelessWidget {
  const _StatisticsPageBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = StatisticsBlocProvider.of(context);
    return StreamBuilder<StatisticsView>(
      stream: bloc.statisticsView,
      builder: (_context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        final view = snapshot.data;
        if (view.hasNotTask) {
          return const _EmptyView();
        }
        return _StatisticsView(
          activeCount: view.activeCount,
          completedCount: view.completedCount,
        );
      },
    );
  }
}

@immutable
class _StatisticsView extends StatelessWidget {
  const _StatisticsView({
    Key key,
    @required this.activeCount,
    @required this.completedCount,
  }) : super(key: key);

  final int activeCount;

  final int completedCount;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final textStyle =
        Theme.of(context).textTheme.subhead.copyWith(fontSize: 18.0);
    return Center(
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          TableRow(children: <Widget>[
            Text(
              strings.statisticsActiveTasks,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
            Text(
              '$activeCount',
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          ]),
          TableRow(children: <Widget>[
            Text(
              strings.statisticsCompletedTasks,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
            Text(
              '$completedCount',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ]),
        ],
      ),
    );
  }
}

@immutable
class _EmptyView extends StatelessWidget {
  const _EmptyView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.poll,
            size: 36.0,
            color: Theme.of(context).primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(S.of(context).noTasks),
          ),
        ],
      ),
    );
  }
}
