// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MaintenanceOrderImpl _$$MaintenanceOrderImplFromJson(
  Map<String, dynamic> json,
) => _$MaintenanceOrderImpl(
  id: json['id'] as String,
  busId: json['busId'] as String,
  status: $enumDecode(_$MaintenanceStatusEnumMap, json['status']),
  type: $enumDecode(_$MaintenanceTypeEnumMap, json['type']),
  plannedAt: json['plannedAt'] == null
      ? null
      : DateTime.parse(json['plannedAt'] as String),
  openedAt: json['openedAt'] == null
      ? null
      : DateTime.parse(json['openedAt'] as String),
  closedAt: json['closedAt'] == null
      ? null
      : DateTime.parse(json['closedAt'] as String),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$MaintenanceOrderImplToJson(
  _$MaintenanceOrderImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'busId': instance.busId,
  'status': _$MaintenanceStatusEnumMap[instance.status]!,
  'type': _$MaintenanceTypeEnumMap[instance.type]!,
  'plannedAt': instance.plannedAt?.toIso8601String(),
  'openedAt': instance.openedAt?.toIso8601String(),
  'closedAt': instance.closedAt?.toIso8601String(),
  'notes': instance.notes,
};

const _$MaintenanceStatusEnumMap = {
  MaintenanceStatus.planned: 'planned',
  MaintenanceStatus.open: 'open',
  MaintenanceStatus.closed: 'closed',
};

const _$MaintenanceTypeEnumMap = {
  MaintenanceType.preventive: 'preventive',
  MaintenanceType.corrective: 'corrective',
};
