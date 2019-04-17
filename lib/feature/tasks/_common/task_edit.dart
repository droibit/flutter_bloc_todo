import 'package:meta/meta.dart';

@immutable
class TaskEdit {
  const TaskEdit({this.title, this.description = ''});

  final String title;
  final String description;

  bool get isCompleted => title?.isNotEmpty ?? false;
}
