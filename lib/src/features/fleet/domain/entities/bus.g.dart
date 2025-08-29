// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusImpl _$$BusImplFromJson(Map<String, dynamic> json) => _$BusImpl(
  id: json['id'] as String,
  plate: json['plate'] as String,
  kmCurrent: (json['kmCurrent'] as num?)?.toInt() ?? 0,
  lastServiceAt: json['lastServiceAt'] == null
      ? null
      : DateTime.parse(json['lastServiceAt'] as String),
  alias: json['alias'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$BusImplToJson(_$BusImpl instance) => <String, dynamic>{
  'id': instance.id,
  'plate': instance.plate,
  'kmCurrent': instance.kmCurrent,
  'lastServiceAt': instance.lastServiceAt?.toIso8601String(),
  'alias': instance.alias,
  'notes': instance.notes,
};
