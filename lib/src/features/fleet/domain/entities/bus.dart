import 'package:freezed_annotation/freezed_annotation.dart';
part 'bus.freezed.dart';
part 'bus.g.dart';

@freezed
class Bus with _$Bus {
  const factory Bus({
    required String id,
    required String plate,
    @Default(0) int kmCurrent,
    DateTime? lastServiceAt,
    String? alias,
    String? notes,
  }) = _Bus;

  factory Bus.fromJson(Map<String, dynamic> json) => _$BusFromJson(json);
}