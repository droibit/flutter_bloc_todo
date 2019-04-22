import 'package:meta/meta.dart';

@immutable
class TaskEditState {
  const TaskEditState({this.title, this.description = ''});

  final String title;
  final String description;

  bool get isCompleted => title?.isNotEmpty ?? false;
}
