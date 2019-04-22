import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
  BuildContext context, {
  @required String message,
}) {
  return Scaffold.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
