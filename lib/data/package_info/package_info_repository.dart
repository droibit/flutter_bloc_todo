import 'package:package_info/package_info.dart';

class PackageInfoRepository {

  factory PackageInfoRepository() {
    _instance ??= const PackageInfoRepository._();
    return _instance;
  }

  const PackageInfoRepository._();

  static PackageInfoRepository _instance;

  Future<PackageInfo> get() => PackageInfo.fromPlatform();
}
