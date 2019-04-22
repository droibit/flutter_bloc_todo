import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class BlocEvent {}

abstract class SimpleBlocBase implements Bloc {
  SimpleBlocBase() {
    _eventSubject.listen(onHandleEvent);
  }

  final _eventSubject = PublishSubject<BlocEvent>();

  void onHandleEvent(BlocEvent event);

  void dispatch(BlocEvent event) {
    assert(event != null);
    _eventSubject.add(event);
  }

  @mustCallSuper
  @override
  void dispose() {
    _eventSubject.close();
  }
}
