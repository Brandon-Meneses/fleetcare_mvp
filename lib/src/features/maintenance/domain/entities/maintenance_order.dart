import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/value_objects/maintenance_enums.dart';
part 'maintenance_order.freezed.dart';
part 'maintenance_order.g.dart';

@freezed
class MaintenanceOrder with _$MaintenanceOrder {
  const factory MaintenanceOrder({
    required String id,
    required String busId,
    required MaintenanceStatus status,
    required MaintenanceType type,
    DateTime? plannedAt,
    DateTime? openedAt,
    DateTime? closedAt,
    String? notes,
  }) = _MaintenanceOrder;

  factory MaintenanceOrder.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceOrderFromJson(json);
}