import 'package:flutter_bloc_todo/utils/logger.dart';
import 'package:injector/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc_todo/data/data.dart';

Future<Injector> configureInjector() async {
  final injector = Injector.appInstance;

  final _prefs = await SharedPreferences.getInstance();
  injector.registerDependency<SharedPreferences>((_) => _prefs);

  injector
      .registerDependency<PackageInfoProvider>((_) => PackageInfoProvider());

  // TODO: register dependencies.

  Logger.log('configured all dependencies.');
  return injector;
}
