import 'package:freezed_annotation/freezed_annotation.dart';
part 'bus.freezed.dart';
part 'bus.g.dart';

@freezed
class Bus with _$Bus {
  const factory Bus({
    required String id,
    required String plate,
    @Default(0) int kmCurrent,

    // fechas que vienen del backend
    DateTime? lastMaintenanceDate,
    DateTime? lastServiceAt, // opcional si tu backend lo usa

    String? alias,
    String? notes,

    // NUEVOS campos del backend
    String? status,
    String? replacementId,
  }) = _Bus;

  factory Bus.fromJson(Map<String, dynamic> json) => _$BusFromJson(json);
}