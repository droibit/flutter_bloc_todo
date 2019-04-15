import 'dart:io';

import 'package:flutter/material.dart';

typedef BackPressedCallback = void Function(BuildContext context);

@immutable
class BackIconButton extends StatelessWidget {
  const BackIconButton({
    Key key,
    BackPressedCallback callback = _defaultBackPressedCallback,
  })  : assert(callback != null),
        _callback = callback,
        super(key: key);

  final BackPressedCallback _callback;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: (Platform.isIOS)
          ? const Icon(Icons.arrow_back_ios)
          : const Icon(Icons.arrow_back),
      onPressed: () => _callback(context),
    );
  }
}

void _defaultBackPressedCallback(BuildContext context) =>
    Navigator.of(context).pop();
