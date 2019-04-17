import 'package:meta/meta.dart';

@immutable
class TaskCompleted {
  const TaskCompleted({
    @required this.id,
    @required this.completed,
  })  : assert(id != null),
        assert(completed != null);

  final String id;
  final bool completed;
}
