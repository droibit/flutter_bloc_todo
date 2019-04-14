import 'package:flutter/material.dart';

import './settings_bloc.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsBlocProvider(
      child: Builder(
        builder: (_context) {
          final SettingsBloc bloc = SettingsBlocProvider.of(_context);
          return const Placeholder();
        },
      ),
    );
  }
}