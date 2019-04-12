import 'package:flutter/widgets.dart';

class NamedRoute {
  NamedRoute(this.name, this.factory);

  final String name;
  final RouteFactory factory;

  NamedRoute copyWith({ String name }) {
    return NamedRoute(name ?? this.name, factory);
  }
}
