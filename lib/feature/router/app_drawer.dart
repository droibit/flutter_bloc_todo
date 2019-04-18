import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/feature/settings/settings_page.dart';
import 'package:flutter_bloc_todo/feature/statistics/statistics_page.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';

enum DrawerNavigation {
  tasks,
  statistics,
  settings,
}

@immutable
class _DrawerNavigationItem {
  const _DrawerNavigationItem(
    this.id, {
    @required this.icon,
    @required this.title,
  });

  final DrawerNavigation id;
  final IconData icon;
  final String title;
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key key,
    @required DrawerNavigation selectedNavItem,
  })  : assert(selectedNavItem != null),
        _selectedNavItem = selectedNavItem,
        super(key: key);

  final DrawerNavigation _selectedNavItem;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[]
          ..add(_buildHeader(context))
          ..addAll(_buildNavItems(context))
          ..add(const Divider())
          ..addAll(_buildFooter(context)),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return DrawerHeader(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/drawer_header_icon.png',
              width: 80.0,
              height: 80.0,
            ),
          ),
          Text(
            S.of(context).appName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(color: Colors.blueGrey[200]),
    );
  }

  List<ListTile> _buildNavItems(BuildContext context) {
    final strings = S.of(context);
    final navItems = <_DrawerNavigationItem>[
      _DrawerNavigationItem(
        DrawerNavigation.tasks,
        icon: Icons.list,
        title: strings.todoList,
      ),
      _DrawerNavigationItem(
        DrawerNavigation.statistics,
        icon: Icons.poll,
        title: strings.statistics,
      ),
    ];

    return _buildNavListTile(context, navItems);
  }

  List<ListTile> _buildFooter(BuildContext context) {
    final navItems = <_DrawerNavigationItem>[
      _DrawerNavigationItem(
        DrawerNavigation.settings,
        icon: Icons.settings,
        title: S.of(context).settings,
      ),
    ];

    return _buildNavListTile(context, navItems);
  }

  List<ListTile> _buildNavListTile(
    BuildContext context,
    List<_DrawerNavigationItem> navItems,
  ) {
    return navItems.map((item) {
      return ListTile(
        leading: Icon(item.icon),
        title: Text(item.title),
        selected: item.id == _selectedNavItem,
        onTap: () => _onNavItemSelected(context, item),
      );
    }).toList(growable: false);
  }

  void _onNavItemSelected(
      BuildContext context, _DrawerNavigationItem destItem) {
    // Hide drawer.
    Navigator.pop(context);

    if (_selectedNavItem == destItem.id) {
      return;
    }

    switch (destItem.id) {
      case DrawerNavigation.tasks:
        Navigator.pop(context);
        break;
      case DrawerNavigation.statistics:
        Navigator.pushNamed(context, StatisticsPage.route.name);
        break;
      case DrawerNavigation.settings:
        Navigator.pushNamed(context, SettingsPage.route.name);
        break;
    }
  }
}
