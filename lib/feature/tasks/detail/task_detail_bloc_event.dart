import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_todo/feature/bloc_base.dart';

@immutable
class ChangeTaskCompletedEvent implements BlocEvent {
  const ChangeTaskCompletedEvent({
    @required this.id,
    @required this.completed,
  })  : assert(id != null),
        assert(completed != null);

  final String id;
  final bool completed;
}
