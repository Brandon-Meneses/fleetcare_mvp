enum MaintenanceStatus { planned, open, closed }
enum MaintenanceType { preventive, corrective }

extension MaintenanceStatusX on MaintenanceStatus {
  String get label => switch (this) {
    MaintenanceStatus.planned => 'PLANIFICADA',
    MaintenanceStatus.open => 'ABIERTA',
    MaintenanceStatus.closed => 'CERRADA',
  };
}