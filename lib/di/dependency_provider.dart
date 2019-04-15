import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:injector/injector.dart';

@immutable
class DependencyProvider extends InheritedWidget {
  const DependencyProvider({
    @required Injector injector,
    @required Widget child,
  })  : _injector = injector,
        super(child: child);

  final Injector _injector;

  PackageInfoRepository get packageInfoRepository => _injector.getDependency();

  UserSettingsRepository get userSettingsRepository =>
      _injector.getDependency();

  TaskRepository get taskRepository => _injector.getDependency();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static DependencyProvider of(BuildContext context) {
    // ignore: avoid_as
    return context
        .ancestorInheritedElementForWidgetOfExactType(DependencyProvider)
        .widget as DependencyProvider;
  }
}
