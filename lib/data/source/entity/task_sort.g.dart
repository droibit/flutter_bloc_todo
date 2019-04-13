// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_sort.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskSort _$TaskSortFromJson(Map<String, dynamic> json) {
  return TaskSort(_$enumDecode(_$SortByEnumMap, json['by']),
      _$enumDecode(_$OrderEnumMap, json['order']));
}

Map<String, dynamic> _$TaskSortToJson(TaskSort instance) => <String, dynamic>{
      'by': _$SortByEnumMap[instance.by],
      'order': _$OrderEnumMap[instance.order]
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

const _$SortByEnumMap = <SortBy, dynamic>{
  SortBy.title: 'title',
  SortBy.created_date: 'created_date'
};

const _$OrderEnumMap = <Order, dynamic>{Order.asc: 'asc', Order.desc: 'desc'};
