import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

@immutable
class DependencyProvider extends InheritedWidget {
  const DependencyProvider({
    @required Injector injector,
    @required Widget child,
  })  : _injector = injector,
        super(child: child);

  final Injector _injector;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static DependencyProvider of(BuildContext context) {
    return context
        .ancestorInheritedElementForWidgetOfExactType(DependencyProvider)
        .widget as DependencyProvider;
  }
}
