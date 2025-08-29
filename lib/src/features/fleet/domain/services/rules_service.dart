import 'dart:math';
import '../entities/bus.dart';
import '../value_objects/bus_state.dart';

class RulesService {
  /// Determina el estado del bus según umbrales.
  static BusState computeState({
    required Bus bus,
    required int kmThreshold,
    required int monthsThreshold,
    DateTime? now,
  }) {
    now ??= DateTime.now();

    // TIEMPO
    if (bus.lastServiceAt != null) {
      final nextByTime = DateTime(
        bus.lastServiceAt!.year,
        bus.lastServiceAt!.month + monthsThreshold,
        bus.lastServiceAt!.day,
      );
      if (!now.isBefore(nextByTime)) {
        return BusState.overdue;
      }
      final daysToTime = nextByTime.difference(now).inDays;
      if (daysToTime <= 14) return BusState.dueSoon;
    }

    // KILOMETRAJE (delta desde último servicio; si null, toma todo el km actual)
    final deltaKm = (bus.kmCurrent - 0) - (0); // placeholder para cuando agregues km en último servicio si lo llevas aparte
    // Para MVP, asumimos delta = kmCurrent desde el último servicio si lastServiceAt != null.
    final effectiveDeltaKm = bus.lastServiceAt == null ? bus.kmCurrent : bus.kmCurrent;
    if (effectiveDeltaKm >= kmThreshold) return BusState.overdue;
    if ((kmThreshold - effectiveDeltaKm) <= 500) return BusState.dueSoon; // margen configurable si quieres

    return BusState.ok;
  }

  /// Predicción: cuándo alcanzará el umbral por KM y/o por TIEMPO (devuelve la fecha más próxima).
  /// Si no hay histórico suficiente, usa [kmPerDayEstimated] si se provee; si no, retorna null.
  static DateTime? predictDueDate({
    required Bus bus,
    required int kmThreshold,
    required int monthsThreshold,
    double? kmPerDayEstimated,
    DateTime? now,
    DateTime? baseDateForRate,
    int? baseKmForRate,
  }) {
    now ??= DateTime.now();

    // Por TIEMPO
    DateTime? dueByTime;
    if (bus.lastServiceAt != null) {
      dueByTime = DateTime(
        bus.lastServiceAt!.year,
        bus.lastServiceAt!.month + monthsThreshold,
        bus.lastServiceAt!.day,
      );
    }

    // Por KM
    DateTime? dueByKm;
    // Calcula km/día: si hay una fecha base (último mantenimiento) y km base, úsalo; si no, recurre al estimado.
    final baseDate = baseDateForRate ?? bus.lastServiceAt;
    final baseKm   = baseKmForRate ?? 0;
    double? kmPerDay;
    if (baseDate != null) {
      final days = max(1, now.difference(baseDate).inDays);
      final delta = (bus.kmCurrent - baseKm).toDouble();
      if (delta > 0 && days >= 7) {
        kmPerDay = delta / days;
      }
    }
    kmPerDay ??= kmPerDayEstimated;

    if (kmPerDay != null && kmPerDay > 0) {
      final remaining = kmThreshold - (bus.kmCurrent - baseKm);
      if (remaining <= 0) {
        dueByKm = now; // ya vencido por km
      } else {
        final days = (remaining / kmPerDay).ceil();
        dueByKm = now.add(Duration(days: days));
      }
    }

    // Decide la fecha más próxima (si ambas existen)
    if (dueByKm != null && dueByTime != null) {
      return dueByKm.isBefore(dueByTime) ? dueByKm : dueByTime;
    }
    return dueByKm ?? dueByTime;
  }
}