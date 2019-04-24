import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc_todo/feature/bloc_base.dart';

@immutable
class CreateTaskEvent implements BlocEvent {
  const CreateTaskEvent({
    @required this.title,
    @required this.description,
  });

  final String title;
  final String description;

  @override
  String toString() {
    return 'CreateTaskEvent{title: $title, description: $description}';
  }
}
