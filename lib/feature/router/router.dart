import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';
import 'package:flutter_bloc_todo/feature/tasks/tasks_page.dart';
import 'paged_route.dart';

final _initialRoute = TasksPage.route.copyWith(name: '/');
final _routes = <NamedRoute>[
  _initialRoute,
  TasksPage.route,
];

final _router = Map<String, RouteFactory>.fromEntries(
  _routes.map((r) => MapEntry(r.name, r.factory)),
);

final RouteFactory onHandleRoute = (settings) {
  Logger.log('onRoute(name=${settings.name})');
  final route = _router[settings.name];
  if (route == null) {
    throw StateError('Unknown route: ${settings.name}');
  }
  return _router[settings.name](settings);
};
