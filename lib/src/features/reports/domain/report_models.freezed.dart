// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReportKpi _$ReportKpiFromJson(Map<String, dynamic> json) {
  return _ReportKpi.fromJson(json);
}

/// @nodoc
mixin _$ReportKpi {
  String get name => throw _privateConstructorUsedError;
  dynamic get value => throw _privateConstructorUsedError;

  /// Serializes this ReportKpi to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportKpi
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportKpiCopyWith<ReportKpi> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportKpiCopyWith<$Res> {
  factory $ReportKpiCopyWith(ReportKpi value, $Res Function(ReportKpi) then) =
      _$ReportKpiCopyWithImpl<$Res, ReportKpi>;
  @useResult
  $Res call({String name, dynamic value});
}

/// @nodoc
class _$ReportKpiCopyWithImpl<$Res, $Val extends ReportKpi>
    implements $ReportKpiCopyWith<$Res> {
  _$ReportKpiCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportKpi
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? value = freezed}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            value: freezed == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as dynamic,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportKpiImplCopyWith<$Res>
    implements $ReportKpiCopyWith<$Res> {
  factory _$$ReportKpiImplCopyWith(
    _$ReportKpiImpl value,
    $Res Function(_$ReportKpiImpl) then,
  ) = __$$ReportKpiImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, dynamic value});
}

/// @nodoc
class __$$ReportKpiImplCopyWithImpl<$Res>
    extends _$ReportKpiCopyWithImpl<$Res, _$ReportKpiImpl>
    implements _$$ReportKpiImplCopyWith<$Res> {
  __$$ReportKpiImplCopyWithImpl(
    _$ReportKpiImpl _value,
    $Res Function(_$ReportKpiImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportKpi
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? value = freezed}) {
    return _then(
      _$ReportKpiImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        value: freezed == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportKpiImpl implements _ReportKpi {
  const _$ReportKpiImpl({required this.name, required this.value});

  factory _$ReportKpiImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportKpiImplFromJson(json);

  @override
  final String name;
  @override
  final dynamic value;

  @override
  String toString() {
    return 'ReportKpi(name: $name, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportKpiImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    const DeepCollectionEquality().hash(value),
  );

  /// Create a copy of ReportKpi
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportKpiImplCopyWith<_$ReportKpiImpl> get copyWith =>
      __$$ReportKpiImplCopyWithImpl<_$ReportKpiImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportKpiImplToJson(this);
  }
}

abstract class _ReportKpi implements ReportKpi {
  const factory _ReportKpi({
    required final String name,
    required final dynamic value,
  }) = _$ReportKpiImpl;

  factory _ReportKpi.fromJson(Map<String, dynamic> json) =
      _$ReportKpiImpl.fromJson;

  @override
  String get name;
  @override
  dynamic get value;

  /// Create a copy of ReportKpi
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportKpiImplCopyWith<_$ReportKpiImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportSection _$ReportSectionFromJson(Map<String, dynamic> json) {
  return _ReportSection.fromJson(json);
}

/// @nodoc
mixin _$ReportSection {
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  /// Serializes this ReportSection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportSectionCopyWith<ReportSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportSectionCopyWith<$Res> {
  factory $ReportSectionCopyWith(
    ReportSection value,
    $Res Function(ReportSection) then,
  ) = _$ReportSectionCopyWithImpl<$Res, ReportSection>;
  @useResult
  $Res call({String title, String content});
}

/// @nodoc
class _$ReportSectionCopyWithImpl<$Res, $Val extends ReportSection>
    implements $ReportSectionCopyWith<$Res> {
  _$ReportSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = null, Object? content = null}) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportSectionImplCopyWith<$Res>
    implements $ReportSectionCopyWith<$Res> {
  factory _$$ReportSectionImplCopyWith(
    _$ReportSectionImpl value,
    $Res Function(_$ReportSectionImpl) then,
  ) = __$$ReportSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String content});
}

/// @nodoc
class __$$ReportSectionImplCopyWithImpl<$Res>
    extends _$ReportSectionCopyWithImpl<$Res, _$ReportSectionImpl>
    implements _$$ReportSectionImplCopyWith<$Res> {
  __$$ReportSectionImplCopyWithImpl(
    _$ReportSectionImpl _value,
    $Res Function(_$ReportSectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportSection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = null, Object? content = null}) {
    return _then(
      _$ReportSectionImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportSectionImpl implements _ReportSection {
  const _$ReportSectionImpl({required this.title, required this.content});

  factory _$ReportSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportSectionImplFromJson(json);

  @override
  final String title;
  @override
  final String content;

  @override
  String toString() {
    return 'ReportSection(title: $title, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportSectionImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, content);

  /// Create a copy of ReportSection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportSectionImplCopyWith<_$ReportSectionImpl> get copyWith =>
      __$$ReportSectionImplCopyWithImpl<_$ReportSectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportSectionImplToJson(this);
  }
}

abstract class _ReportSection implements ReportSection {
  const factory _ReportSection({
    required final String title,
    required final String content,
  }) = _$ReportSectionImpl;

  factory _ReportSection.fromJson(Map<String, dynamic> json) =
      _$ReportSectionImpl.fromJson;

  @override
  String get title;
  @override
  String get content;

  /// Create a copy of ReportSection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportSectionImplCopyWith<_$ReportSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportResponse _$ReportResponseFromJson(Map<String, dynamic> json) {
  return _ReportResponse.fromJson(json);
}

/// @nodoc
mixin _$ReportResponse {
  String get summary => throw _privateConstructorUsedError;
  List<ReportKpi> get kpis => throw _privateConstructorUsedError;
  List<ReportSection> get sections => throw _privateConstructorUsedError;
  String get dataHash => throw _privateConstructorUsedError;

  /// Serializes this ReportResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportResponseCopyWith<ReportResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportResponseCopyWith<$Res> {
  factory $ReportResponseCopyWith(
    ReportResponse value,
    $Res Function(ReportResponse) then,
  ) = _$ReportResponseCopyWithImpl<$Res, ReportResponse>;
  @useResult
  $Res call({
    String summary,
    List<ReportKpi> kpis,
    List<ReportSection> sections,
    String dataHash,
  });
}

/// @nodoc
class _$ReportResponseCopyWithImpl<$Res, $Val extends ReportResponse>
    implements $ReportResponseCopyWith<$Res> {
  _$ReportResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? kpis = null,
    Object? sections = null,
    Object? dataHash = null,
  }) {
    return _then(
      _value.copyWith(
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String,
            kpis: null == kpis
                ? _value.kpis
                : kpis // ignore: cast_nullable_to_non_nullable
                      as List<ReportKpi>,
            sections: null == sections
                ? _value.sections
                : sections // ignore: cast_nullable_to_non_nullable
                      as List<ReportSection>,
            dataHash: null == dataHash
                ? _value.dataHash
                : dataHash // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportResponseImplCopyWith<$Res>
    implements $ReportResponseCopyWith<$Res> {
  factory _$$ReportResponseImplCopyWith(
    _$ReportResponseImpl value,
    $Res Function(_$ReportResponseImpl) then,
  ) = __$$ReportResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String summary,
    List<ReportKpi> kpis,
    List<ReportSection> sections,
    String dataHash,
  });
}

/// @nodoc
class __$$ReportResponseImplCopyWithImpl<$Res>
    extends _$ReportResponseCopyWithImpl<$Res, _$ReportResponseImpl>
    implements _$$ReportResponseImplCopyWith<$Res> {
  __$$ReportResponseImplCopyWithImpl(
    _$ReportResponseImpl _value,
    $Res Function(_$ReportResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? kpis = null,
    Object? sections = null,
    Object? dataHash = null,
  }) {
    return _then(
      _$ReportResponseImpl(
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String,
        kpis: null == kpis
            ? _value._kpis
            : kpis // ignore: cast_nullable_to_non_nullable
                  as List<ReportKpi>,
        sections: null == sections
            ? _value._sections
            : sections // ignore: cast_nullable_to_non_nullable
                  as List<ReportSection>,
        dataHash: null == dataHash
            ? _value.dataHash
            : dataHash // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportResponseImpl implements _ReportResponse {
  const _$ReportResponseImpl({
    required this.summary,
    required final List<ReportKpi> kpis,
    required final List<ReportSection> sections,
    required this.dataHash,
  }) : _kpis = kpis,
       _sections = sections;

  factory _$ReportResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportResponseImplFromJson(json);

  @override
  final String summary;
  final List<ReportKpi> _kpis;
  @override
  List<ReportKpi> get kpis {
    if (_kpis is EqualUnmodifiableListView) return _kpis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_kpis);
  }

  final List<ReportSection> _sections;
  @override
  List<ReportSection> get sections {
    if (_sections is EqualUnmodifiableListView) return _sections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sections);
  }

  @override
  final String dataHash;

  @override
  String toString() {
    return 'ReportResponse(summary: $summary, kpis: $kpis, sections: $sections, dataHash: $dataHash)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportResponseImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(other._kpis, _kpis) &&
            const DeepCollectionEquality().equals(other._sections, _sections) &&
            (identical(other.dataHash, dataHash) ||
                other.dataHash == dataHash));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    summary,
    const DeepCollectionEquality().hash(_kpis),
    const DeepCollectionEquality().hash(_sections),
    dataHash,
  );

  /// Create a copy of ReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportResponseImplCopyWith<_$ReportResponseImpl> get copyWith =>
      __$$ReportResponseImplCopyWithImpl<_$ReportResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportResponseImplToJson(this);
  }
}

abstract class _ReportResponse implements ReportResponse {
  const factory _ReportResponse({
    required final String summary,
    required final List<ReportKpi> kpis,
    required final List<ReportSection> sections,
    required final String dataHash,
  }) = _$ReportResponseImpl;

  factory _ReportResponse.fromJson(Map<String, dynamic> json) =
      _$ReportResponseImpl.fromJson;

  @override
  String get summary;
  @override
  List<ReportKpi> get kpis;
  @override
  List<ReportSection> get sections;
  @override
  String get dataHash;

  /// Create a copy of ReportResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportResponseImplCopyWith<_$ReportResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
