import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_todo/feature/bloc_base.dart';

@immutable
class EditTaskEvent implements BlocEvent {
  const EditTaskEvent({this.title, this.description = ''});

  final String title;
  final String description;
}
