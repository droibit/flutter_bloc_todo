import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/feature/_widgets/BackIconButton.dart';
import 'package:flutter_bloc_todo/feature/router/paged_route.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import './settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  static final route = NamedRoute(
    '/settings',
    (settings) => MaterialPageRoute<SettingsPage>(
          builder: (_) => SettingsPage(),
          settings: settings,
          fullscreenDialog: true,
        ),
  );

  @override
  Widget build(BuildContext context) {
    return SettingsBlocProvider(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).settings),
          leading: const BackIconButton(),
        ),
        body: _SettingsPageBody(),
      ),
    );
  }
}

@immutable
class _SettingsPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[]..addAll(_buildAppCategory(context)),
    );
  }

  List<Widget> _buildAppCategory(BuildContext context) {
    final strings = S.of(context);
    final bloc = SettingsBlocProvider.of(context);
    return <Widget>[
      _Category(title: strings.settings),
    ]..addAll(
        ListTile.divideTiles(
          context: context,
          tiles: <Widget>[
            ListTile(
              title: Text(strings.sourceCodeTitle),
              subtitle: const Text('github.com'),
              onTap: () => _onSourceCodeTap(context),
            ),
            StreamBuilder<PackageInfo>(
              stream: bloc.packageInfo,
              builder: (_, snapshot) {
                final packageInfo = snapshot.data;
                Logger.log('build app version($packageInfo).');

                return ListTile(
                  title: Text(strings.buildVersionTitle),
                  subtitle: packageInfo == null
                      ? null
                      : Text(
                          strings.buildVersionSubtitle(packageInfo.version),
                        ),
                );
              },
            ),
          ],
        ),
      );
  }

  Future<void> _onSourceCodeTap(BuildContext context) async {
    await launch(
      'https://github.com/droibit/flutter_bloc_todo',
      option: CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
      ),
    );
  }
}

@immutable
class _Category extends StatelessWidget {
  const _Category({
    @required this.title,
    Key key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.bottomLeft,
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
