import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> showShortToast({@required String msg}) {
  return Fluttertoast.showToast(
    msg: msg,
    timeInSecForIos: 2,
    toastLength: Toast.LENGTH_SHORT,
  );
}

Future<bool> showLongToast({@required String msg}) {
  return Fluttertoast.showToast(
    msg: msg,
    timeInSecForIos: 4,
    toastLength: Toast.LENGTH_LONG,
  );
}
