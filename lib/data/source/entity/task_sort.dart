import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_sort.g.dart';

enum SortBy { title, created_date }

enum Order { asc, desc }

@immutable
@JsonSerializable(nullable: false)
class TaskSort {

  const TaskSort(this.by, this.order);

  factory TaskSort.fromMap(Map<String, dynamic> json) => _$TaskSortFromJson(json);

  final SortBy by;

  final Order order;

  TaskSort reverseOrder() {
    return copyWith(order: order == Order.asc ? Order.desc : Order.asc);
  }

  TaskSort copyWith({
    SortBy by,
    Order order,
  }) {
    return TaskSort(
      by ?? this.by,
      order ?? this.order,
    );
  }

  Map<String, dynamic> toJson() => _$TaskSortToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskSort &&
          runtimeType == other.runtimeType &&
          by == other.by &&
          order == other.order;

  @override
  int get hashCode => by.hashCode ^ order.hashCode;

  @override
  String toString() {
    return 'TaskSort{by: $by, order: $order}';
  }
}
