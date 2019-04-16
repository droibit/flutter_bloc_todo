import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/feature/router/router.dart';
import 'package:flutter_bloc_todo/feature/tasks/new/new_task_page.dart';
import 'package:flutter_bloc_todo/feature/tasks/tasks_bloc.dart';
import 'package:flutter_bloc_todo/feature/tasks/tasks_page_body.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';


class TasksPage extends StatelessWidget {
  static final route = NamedRoute(
    '/tasks',
    (settings) => FadePageRoute<void>(
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
        drawer: const AppDrawer(
          selectedNavItem: DrawerNavigation.tasks,
        ),
        body: const TasksPageBody(),
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

  void _onMenuItemSelected(BuildContext context, TasksFilter newFilter) {
    Logger.log('onMenuItemSelected(item=$newFilter)');
    final bloc = TasksBlocProvider.of(context);
    bloc.changeTaskFilter.add(newFilter);
  }
}

enum _OverflowMenuItem {
  changeTasksSortBy,
  clearCompletedTasks,
}

@immutable
class _OverflowPopupMenu extends StatelessWidget {
  const _OverflowPopupMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final items = <_OverflowMenuItem, String>{
      _OverflowMenuItem.changeTasksSortBy: strings.todoListSortBy,
      _OverflowMenuItem.clearCompletedTasks: strings.todoListClearCompleted,
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
      case _OverflowMenuItem.changeTasksSortBy:
        _showSortTasksBottomSheet(context);
        break;
      case _OverflowMenuItem.clearCompletedTasks:
        break;
    }
  }

  Future<void> _showSortTasksBottomSheet(BuildContext context) async {
    final strings = S.of(context);
    final items = <SortBy, String>{
      SortBy.title: strings.todoListSortByTitle,
      SortBy.created_date: strings.todoListSortByCreatedDate,
    };

    final bloc = TasksBlocProvider.of(context);
    final currentTaskSort = bloc.taskSort.value;
    final selectedSortBy = await showModalBottomSheet<SortBy>(
      context: context,
      builder: (_context) {
        return ListView(
          shrinkWrap: true,
          children: <ListTile>[
            ListTile(
              title: Text(
                strings.todoListSortBy,
                style: TextStyle(
                  color: Theme.of(_context).primaryColorDark,
                ),
              ),
              onTap: null,
            ),
          ]..addAll(
              items.entries.map((entry) {
                return ListTile(
                  title: Text(entry.value),
                  onTap: () => Navigator.pop(_context, entry.key),
                  trailing: currentTaskSort.by == entry.key
                      ? const Icon(Icons.check)
                      : null,
                );
              }),
            ),
        );
      },
    );

    if (currentTaskSort.by != selectedSortBy) {
      bloc.changeTaskSort.add(
        currentTaskSort.copyWith(by: selectedSortBy),
      );
    }
  }
}

@immutable
class _NewTaskButton extends StatelessWidget {
  const _NewTaskButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => _navigateToNewTask(context),
    );
  }

  Future<void> _navigateToNewTask(BuildContext context) async {
    final bool successful =
        await Navigator.pushNamed(context, NewTaskPage.route.name);

    if (successful == null) {
      return;
    }

    final strings = S.of(context);
    _showSnackBar(
      context,
      message: successful
          ? strings.newTaskSuccessfulToCreate
          : strings.newTaskFailedToCreate,
    );
  }
}

void _showSnackBar(BuildContext context, {@required String message}) {
  Scaffold.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
