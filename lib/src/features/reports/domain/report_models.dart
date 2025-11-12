import 'package:freezed_annotation/freezed_annotation.dart';
part 'report_models.freezed.dart';
part 'report_models.g.dart';

@freezed
class ReportKpi with _$ReportKpi {
  const factory ReportKpi({
    required String name,
    required dynamic value,   // ← permite int, double o string
  }) = _ReportKpi;

  factory ReportKpi.fromJson(Map<String, dynamic> json) =>
      _$ReportKpiFromJson(json);
}

@freezed
class ReportSection with _$ReportSection {
  const factory ReportSection({
    required String title,
    required String content,
  }) = _ReportSection;

  factory ReportSection.fromJson(Map<String, dynamic> json) => _$ReportSectionFromJson(json);
}

@freezed
class ReportResponse with _$ReportResponse {
  const factory ReportResponse({
    required String summary,
    required List<ReportKpi> kpis,
    required List<ReportSection> sections,
    required String dataHash, // para trazabilidad mínima
  }) = _ReportResponse;

  factory ReportResponse.fromJson(Map<String, dynamic> json) => _$ReportResponseFromJson(json);
}