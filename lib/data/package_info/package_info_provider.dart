import 'package:package_info/package_info.dart';

class PackageInfoProvider {

  factory PackageInfoProvider() {
    _instance ??= const PackageInfoProvider._();
    return _instance;
  }

  const PackageInfoProvider._();

  static PackageInfoProvider _instance;

  Future<PackageInfo> get() => PackageInfo.fromPlatform();
}
