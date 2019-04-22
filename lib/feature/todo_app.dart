import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/generated/i18n.dart';
import 'package:flutter_bloc_todo/router/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class TodoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => S.of(context).appName,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: S.delegate.resolution(
        fallback: const Locale('en', ''),
        withCountry: false,
      ),
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.redAccent,
      ),
      onGenerateRoute: onHandleRoute,
    );
  }
}
