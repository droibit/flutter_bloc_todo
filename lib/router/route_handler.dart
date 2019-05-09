import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/feature/settings/settings_page.dart';
import 'package:flutter_bloc_todo/feature/statistics/statistics_page.dart';
import 'package:flutter_bloc_todo/feature/tasks/detail/task_detail_page.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/new/new_task_page.dart';
import 'package:flutter_bloc_todo/feature/tasks/edit/update/update_task_page.dart';
import 'package:flutter_bloc_todo/feature/tasks/tasks_page.dart';
import 'package:flutter_bloc_todo/router/named_route.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';

final _initialRoute = TasksPage.route.copyWith(name: '/');
// TODO: Comment out if you want to switch initial page on app launched.
//final _initialRoute = NamedRoute(
//  '/',
//      (settings) =>
//      MaterialPageRoute<TasksPage>(
//        builder: (context) {
//          final deps = DependencyProvider.of(context);
//          deps.userSettingsRepository
//          return TasksPage(title: 'Flutter Demo Home Page');
//        },
//        settings: settings,
//      ),
//);
final _routes = <NamedRoute>[
  _initialRoute,
  TasksPage.route,
  NewTaskPage.route,
  TaskDetailPage.route,
  UpdateTaskPage.route,
  StatisticsPage.route,
  SettingsPage.route,
];

final _router = <String, RouteFactory>{
  for (var route in _routes) route.name: route.factory,
};

Route<dynamic> onHandleRoute(RouteSettings settings) {
  Logger.log('onRoute(name=${settings.name})');
  final route = _router[settings.name];
  if (route == null) {
    throw StateError('Unknown route: ${settings.name}');
  }
  return _router[settings.name](settings);
}
