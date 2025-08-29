enum BusState { ok, dueSoon, overdue }

extension BusStateX on BusState {
  String get label => switch (this) {
    BusState.ok => 'OK',
    BusState.dueSoon => 'Próximo',
    BusState.overdue => 'Vencido',
  };
}