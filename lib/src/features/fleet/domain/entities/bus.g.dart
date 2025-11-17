// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusImpl _$$BusImplFromJson(Map<String, dynamic> json) => _$BusImpl(
  id: json['id'] as String,
  plate: json['plate'] as String,
  kmCurrent: (json['kmCurrent'] as num?)?.toInt() ?? 0,
  lastMaintenanceDate: json['lastMaintenanceDate'] == null
      ? null
      : DateTime.parse(json['lastMaintenanceDate'] as String),
  lastServiceAt: json['lastServiceAt'] == null
      ? null
      : DateTime.parse(json['lastServiceAt'] as String),
  alias: json['alias'] as String?,
  notes: json['notes'] as String?,
  status: json['status'] as String?,
  replacementId: json['replacementId'] as String?,
);

Map<String, dynamic> _$$BusImplToJson(_$BusImpl instance) => <String, dynamic>{
  'id': instance.id,
  'plate': instance.plate,
  'kmCurrent': instance.kmCurrent,
  'lastMaintenanceDate': instance.lastMaintenanceDate?.toIso8601String(),
  'lastServiceAt': instance.lastServiceAt?.toIso8601String(),
  'alias': instance.alias,
  'notes': instance.notes,
  'status': instance.status,
  'replacementId': instance.replacementId,
};
