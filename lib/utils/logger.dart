import 'package:flutter/foundation.dart';

class _LoggerDelegate {
  const _LoggerDelegate();

  void log(String message) {}
}

class _DebugLoggerDelegate extends _LoggerDelegate {
  const _DebugLoggerDelegate();

  @override
  void log(String message) {
    debugPrint(message);
  }
}

class Logger {
  static const _LoggerDelegate _delegate = bool.fromEnvironment(
      'dart.vm.product') ? _LoggerDelegate() : _DebugLoggerDelegate();

  static void log(String message) {
    _delegate.log(message);
  }
}

