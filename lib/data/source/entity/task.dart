import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable(nullable: false)
@immutable
class Task {
  const Task({
    @required this.id,
    @required this.title,
    @required this.timestamp,
    this.description = '',
    this.completed = false,
  })  : assert(id != null),
        assert(title != null),
        assert(description != null),
        assert(timestamp != null),
        assert(completed != null);

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  final String id;

  final String title;

  final String description;

  final DateTime timestamp;

  final bool completed;

  bool get isActive => !completed;

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task copyWith({
    String id,
    String title,
    String description,
    DateTime timestamp,
    bool completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      completed: completed ?? this.completed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          timestamp == other.timestamp &&
          completed == other.completed;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      timestamp.hashCode ^
      completed.hashCode;

  @override
  String toString() {
    return 'Task{id: $id, title: $title, description: $description, timestamp: $timestamp, completed: $completed}';
  }
}
