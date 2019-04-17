import 'package:flutter/widgets.dart';

@immutable
class NamedRoute {
  const NamedRoute(this.name, this.factory);

  final String name;
  final RouteFactory factory;

  NamedRoute copyWith({
    String name,
    RouteFactory factory,
  }) {
    return NamedRoute(name ?? this.name, factory ?? this.factory);
  }
}
