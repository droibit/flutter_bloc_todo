import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/feature/router/paged_route.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';

class TasksPage extends StatelessWidget {
  static final route = NamedRoute(
    '/tasks',
    (settings) => MaterialPageRoute<TasksPage>(
          builder: (_) => TasksPage(),
          settings: settings,
        ),
  );

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.appName),
      ),
      body: Center(
        child: const Text('TODO'),
      ),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    );
  }
}
