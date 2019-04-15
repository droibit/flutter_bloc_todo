import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/utils/logger.dart';
import 'package:injector/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Injector> configureInjector() async {
  final injector = Injector.appInstance;

  final _prefs = await SharedPreferences.getInstance();
  injector.registerDependency<SharedPreferences>((_) => _prefs);

  injector.registerSingleton(
    (_injector) => LocalSource(sharedPrefs: _injector.getDependency()),
  );

  injector.registerSingleton<PackageInfoRepository>(
    (_) => PackageInfoRepository(),
  );

  injector.registerSingleton<UserSettingsRepository>(
    (_injector) =>
        UserSettingsRepository(localSource: _injector.getDependency()),
  );

  injector.registerSingleton<TaskRepository>(
    (_injector) => TaskRepository(localSource: _injector.getDependency()),
  );

  // TODO: register dependencies.

  Logger.log('configured all dependencies.');
  return injector;
}
