// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportKpiImpl _$$ReportKpiImplFromJson(Map<String, dynamic> json) =>
    _$ReportKpiImpl(
      name: json['name'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$$ReportKpiImplToJson(_$ReportKpiImpl instance) =>
    <String, dynamic>{'name': instance.name, 'value': instance.value};

_$ReportSectionImpl _$$ReportSectionImplFromJson(Map<String, dynamic> json) =>
    _$ReportSectionImpl(
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$$ReportSectionImplToJson(_$ReportSectionImpl instance) =>
    <String, dynamic>{'title': instance.title, 'content': instance.content};

_$ReportResponseImpl _$$ReportResponseImplFromJson(Map<String, dynamic> json) =>
    _$ReportResponseImpl(
      summary: json['summary'] as String,
      kpis: (json['kpis'] as List<dynamic>)
          .map((e) => ReportKpi.fromJson(e as Map<String, dynamic>))
          .toList(),
      sections: (json['sections'] as List<dynamic>)
          .map((e) => ReportSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      dataHash: json['dataHash'] as String,
    );

Map<String, dynamic> _$$ReportResponseImplToJson(
  _$ReportResponseImpl instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'kpis': instance.kpis,
  'sections': instance.sections,
  'dataHash': instance.dataHash,
};
