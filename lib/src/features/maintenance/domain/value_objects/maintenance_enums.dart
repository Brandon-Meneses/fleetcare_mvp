import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_enums.g.dart';

@JsonEnum(alwaysCreate: true)
enum MaintenanceStatus {
  @JsonValue('PLANNED')
  planned,

  @JsonValue('OPEN')
  open,

  @JsonValue('CLOSED')
  closed,
}

@JsonEnum(alwaysCreate: true)
enum MaintenanceType {
  @JsonValue('PREVENTIVE')
  preventive,

  @JsonValue('CORRECTIVE')
  corrective,
}

extension MaintenanceStatusX on MaintenanceStatus {
  String get label => switch (this) {
    MaintenanceStatus.planned => 'PLANIFICADA',
    MaintenanceStatus.open => 'ABIERTA',
    MaintenanceStatus.closed => 'CERRADA',
  };
}