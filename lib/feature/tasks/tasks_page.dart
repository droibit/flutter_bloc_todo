import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/feature/router/router.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';

import './tasks_bloc.dart';

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
    return TasksBlocProvider(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).appName),
          centerTitle: Platform.isIOS,
          elevation: 0.0,
          actions: const <Widget>[
            _TasksFilterPopupMenu(),
            _OverflowPopupMenu(),
          ],
        ),
        body: Center(
          child: const Text('TODO'),
        ),
        floatingActionButton: const _NewTaskButton(),
      ),
    );
  }
}

@immutable
class _TasksFilterPopupMenu extends StatelessWidget {
  const _TasksFilterPopupMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final items = <TasksFilter, String>{
      TasksFilter.all: strings.todoListFilterAll,
      TasksFilter.active: strings.todoListFilterActive,
      TasksFilter.completed: strings.todoListFilterCompleted,
    };
    return PopupMenuButton<TasksFilter>(
      icon: const Icon(Icons.filter_list),
      itemBuilder: (_) => items.entries
          .map(
            (item) => PopupMenuItem<TasksFilter>(
                  value: item.key,
                  child: Text(item.value),
                ),
          )
          .toList(growable: false),
      onSelected: (item) => _onMenuItemSelected(context, item),
    );
  }

  void _onMenuItemSelected(BuildContext context, TasksFilter item) {
    Logger.log('onMenuItemSelected(item=$item)');
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
      itemBuilder: (_) => items.entries
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
    Logger.log('onMenuItemSelected(item=$item)');
    switch (item) {
      case _OverflowMenuItem.clearCompletedTasks:
        break;
      case _OverflowMenuItem.settings:
        Navigator.of(context).pushNamed(SettingsPage.route.name);
        break;
    }
  }
}

class _NewTaskButton extends StatelessWidget {
  const _NewTaskButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: null,
    );
  }
}
