import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/feature/router/paged_route.dart';
import 'package:flutter_bloc_todo/feature/settings/settings_page.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';
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
        actions: const <Widget>[
          _OverflowPopupMenu(),
        ],
      ),
      body: Center(
        child: const Text('TODO'),
      ),
    );
  }
}

enum _OverflowMenuItem {
  clearCompletedTasks,
  settings,
}

@immutable
class _OverflowPopupMenu extends StatelessWidget {
  const _OverflowPopupMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final items = <_OverflowMenuItem, String>{
      _OverflowMenuItem.clearCompletedTasks: strings.todoListClearCompleted,
      _OverflowMenuItem.settings: strings.settings,
    };

    return PopupMenuButton<_OverflowMenuItem>(
      icon: (Platform.isIOS)
          ? const Icon(Icons.more_horiz)
          : const Icon(Icons.more_vert),
      itemBuilder: (_context) => items.entries
          .map(
            (item) => PopupMenuItem<_OverflowMenuItem>(
                  value: item.key,
                  child: Text(item.value),
                ),
          )
          .toList(growable: false),
      onSelected: (item) => _onMenuItemSelected(context, item),
    );
  }

  void _onMenuItemSelected(BuildContext context, _OverflowMenuItem item) {
    Logger.log('onMenuItemSelected(item=$item');
    switch (item) {
      case _OverflowMenuItem.clearCompletedTasks:
        break;
      case _OverflowMenuItem.settings:
        Navigator.of(context).pushNamed(SettingsPage.route.name);
        break;
    }
  }
}
