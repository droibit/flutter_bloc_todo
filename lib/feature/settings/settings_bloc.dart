import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_todo/data/data.dart';
import 'package:flutter_bloc_todo/di/di.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc implements Bloc {
  SettingsBloc({
    @required PackageInfoRepository packageInfoRepository,
  }) : _packageInfoRepository = packageInfoRepository;

  final PackageInfoRepository _packageInfoRepository;

  Observable<PackageInfo> _packageInfoObservable;

  Observable<PackageInfo> get packageInfo {
    _packageInfoObservable ??= Observable(
      Stream.fromFuture(_packageInfoRepository.get()),
    );
    return _packageInfoObservable;
  }

  @override
  void dispose() {}
}

@immutable
class SettingsBlocProvider extends BlocProvider<SettingsBloc> {
  SettingsBlocProvider({
    @required Widget child,
  })  : assert(child != null),
        super(
          creator: (context, _) {
            final deps = DependencyProvider.of(context);
            return SettingsBloc(
              packageInfoRepository: deps.packageInfoRepository,
            );
          },
          child: child,
        );

  static SettingsBloc of(BuildContext context) => BlocProvider.of(context);
}
