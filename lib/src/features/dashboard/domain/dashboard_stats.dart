import '../../fleet/domain/entities/bus.dart';

class DashboardStats {
  final int totalBuses;
  final int ok;
  final int dueSoon;
  final int overdue;

  final int planned;
  final int open;
  final int closed;

  final List<Bus> topOverdue; // para mostrar los más urgentes

  const DashboardStats({
    required this.totalBuses,
    required this.ok,
    required this.dueSoon,
    required this.overdue,
    required this.planned,
    required this.open,
    required this.closed,
    required this.topOverdue,
  });
}