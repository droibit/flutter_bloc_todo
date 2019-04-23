import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/foundation.dart';

class BlocEvent {}

abstract class SimpleBlocBase implements Bloc {
  SimpleBlocBase() {
    _eventController.stream.listen(onHandleEvent);
  }

  final _eventController = StreamController<BlocEvent>();

  Sink<BlocEvent> get events => _eventController.sink;

  @protected
  void onHandleEvent(BlocEvent event);

  @mustCallSuper
  @override
  void dispose() {
    _eventController.close();
  }
}
