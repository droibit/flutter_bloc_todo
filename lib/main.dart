import 'package:flutter/material.dart';
import 'di/di.dart';
import 'feature/todo_app.dart';

Future<void> main() async {
  final injector = await configureInjector();
  runApp(
    DependencyProvider(
      injector: injector,
      child: TodoApp(),
    ),
  );
}
