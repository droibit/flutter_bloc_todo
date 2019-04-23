import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/feature/tasks/detail/task_detail_page.dart';
import 'package:flutter_bloc_todo/feature/tasks/tasks_bloc.dart';
import 'package:flutter_bloc_todo/feature/tasks/tasks_bloc_event.dart';
import 'package:flutter_bloc_todo/feature/tasks/tasks_state.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';

@immutable
class TasksPageBody extends StatelessWidget {
  const TasksPageBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = TasksBlocProvider.of(context);
    return StreamBuilder<TasksState>(
      stream: bloc.tasksState,
      builder: (_context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: const CircularProgressIndicator());
        }

        final state = snapshot.data;
        if (state.tasks.isEmpty) {
          return const _EmptyView();
        }
        return _TaskListView(state: state);
      },
    );
  }
}

@immutable
class _TaskListView extends StatelessWidget {
  const _TaskListView({
    Key key,
    this.state,
  }) : super(key: key);

  final TasksState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _TaskListHeader(
          tasksFilter: state.filter,
          taskSort: state.taskSort,
        ),
        Expanded(
          child: ListView.separated(
            itemCount: state.tasks.length,
            itemBuilder: (_context, index) {
              final task = state.tasks[index];
              return ListTile(
                key: ObjectKey(task),
                leading: Checkbox(
                  value: task.completed,
                  onChanged: (checked) =>
                      _onTaskItemChecked(context, task, checked),
                ),
                title: Text(
                  task.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => _onTaskItemTap(context, task),
              );
            },
            separatorBuilder: (_, __) => const Divider(),
          ),
        )
      ],
    );
  }

  void _onTaskItemChecked(BuildContext context, Task task, bool completed) {
    final bloc = TasksBlocProvider.of(context);
    bloc.events.add(
      ChangeTaskCompletedEvent(id: task.id, completed: completed),
    );
  }

  void _onTaskItemTap(BuildContext context, Task task) {
    Logger.log('onTaskItemTap(task=${task.title})');
    Navigator.pushNamed(
      context,
      TaskDetailPage.route.name,
      arguments: task,
    );
  }
}

@immutable
class _TaskListHeader extends StatelessWidget {
  const _TaskListHeader({
    Key key,
    @required this.tasksFilter,
    @required this.taskSort,
  }) : super(key: key);

  final TasksFilter tasksFilter;

  final TaskSort taskSort;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.primaryColor,
      elevation: 4.0,
      child: Column(
        children: <Widget>[
          const Divider(
            height: 2.0,
            color: Colors.white24,
          ),
          Container(
            constraints: const BoxConstraints(
              minHeight: 48.0,
              maxHeight: 48.0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _convertHeaderTitle(context, tasksFilter),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: theme.textTheme.subhead.fontSize,
                  ),
                ),
                Material(
                  type: MaterialType.card,
                  color: theme.primaryColor,
                  child: InkWell(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            _convertSortByText(context, taskSort.by),
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: theme.textTheme.subhead.fontSize,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            _convertSortOrderIcon(taskSort.order),
                            size: 20,
                            color: Colors.white70,
                          ),
                        )
                      ],
                    ),
                    onTap: () => _onTaskSortTap(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _convertHeaderTitle(BuildContext context, TasksFilter filter) {
    switch (filter) {
      case TasksFilter.all:
        return S.of(context).todoListHeaderAll;
      case TasksFilter.active:
        return S.of(context).todoListHeaderActive;
      case TasksFilter.completed:
        return S.of(context).todoListHeaderCompleted;
      default:
        throw ArgumentError('Unknown filter');
    }
  }

  String _convertSortByText(BuildContext context, SortBy sortBy) {
    switch (sortBy) {
      case SortBy.title:
        return S.of(context).todoListSortByTitle;
      case SortBy.created_date:
        return S.of(context).todoListSortByCreatedDate;
      default:
        throw AssertionError('Unknown sortBy: $sortBy');
    }
  }

  IconData _convertSortOrderIcon(Order order) {
    return order == Order.asc ? Icons.arrow_upward : Icons.arrow_downward;
  }

  Future<void> _onTaskSortTap(BuildContext context) async {
    final strings = S.of(context);
    final items = <SortBy, String>{
      SortBy.title: strings.todoListSortByTitle,
      SortBy.created_date: strings.todoListSortByCreatedDate,
    };

    final bloc = TasksBlocProvider.of(context);
    final selectedSortBy = await showModalBottomSheet<SortBy>(
      context: context,
      builder: (_context) {
        final theme = Theme.of(_context);
        return ListView(
          shrinkWrap: true,
          children: <ListTile>[
            ListTile(
              title: Text(
                strings.todoListSortBy,
                style: TextStyle(
                  color: theme.primaryColorDark,
                ),
              ),
              onTap: null,
            ),
          ]..addAll(
              items.entries.map((entry) {
                final selectedSort = entry.key == taskSort.by;
                return ListTile(
                  leading: selectedSort
                      ? Icon(_convertSortOrderIcon(taskSort.order))
                      : SizedBox.fromSize(
                          size: Size.square(theme.iconTheme.size),
                        ),
                  title: Text(entry.value),
                  onTap: () => Navigator.pop(_context, entry.key),
                  trailing: selectedSort
                      ? Icon(Icons.check, color: theme.accentColor)
                      : null,
                );
              }),
            ),
        );
      },
    );

    if (selectedSortBy == null) {
      return;
    }

    TaskSort newTaskSort;
    if (taskSort.by == selectedSortBy) {
      newTaskSort = taskSort.reverseOrder();
    } else {
      newTaskSort = taskSort.copyWith(by: selectedSortBy);
    }
    bloc.events.add(ChangeTaskSortEvent(newTaskSort));
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
            Icons.assignment_turned_in,
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
