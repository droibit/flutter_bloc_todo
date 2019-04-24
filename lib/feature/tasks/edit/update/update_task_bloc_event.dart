import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_todo/feature/bloc_base.dart';

@immutable
class UpdateTaskEvent implements BlocEvent {
  const UpdateTaskEvent({
    @required this.title,
    @required this.description,
  });

  final String title;
  final String description;

  @override
  String toString() {
    return 'UpdateTaskEvent{title: $title, description: $description}';
  }
}
