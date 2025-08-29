// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bus.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Bus _$BusFromJson(Map<String, dynamic> json) {
  return _Bus.fromJson(json);
}

/// @nodoc
mixin _$Bus {
  String get id => throw _privateConstructorUsedError;
  String get plate => throw _privateConstructorUsedError;
  int get kmCurrent => throw _privateConstructorUsedError;
  DateTime? get lastServiceAt => throw _privateConstructorUsedError;
  String? get alias => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this Bus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Bus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusCopyWith<Bus> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusCopyWith<$Res> {
  factory $BusCopyWith(Bus value, $Res Function(Bus) then) =
      _$BusCopyWithImpl<$Res, Bus>;
  @useResult
  $Res call({
    String id,
    String plate,
    int kmCurrent,
    DateTime? lastServiceAt,
    String? alias,
    String? notes,
  });
}

/// @nodoc
class _$BusCopyWithImpl<$Res, $Val extends Bus> implements $BusCopyWith<$Res> {
  _$BusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Bus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? plate = null,
    Object? kmCurrent = null,
    Object? lastServiceAt = freezed,
    Object? alias = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            plate: null == plate
                ? _value.plate
                : plate // ignore: cast_nullable_to_non_nullable
                      as String,
            kmCurrent: null == kmCurrent
                ? _value.kmCurrent
                : kmCurrent // ignore: cast_nullable_to_non_nullable
                      as int,
            lastServiceAt: freezed == lastServiceAt
                ? _value.lastServiceAt
                : lastServiceAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            alias: freezed == alias
                ? _value.alias
                : alias // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BusImplCopyWith<$Res> implements $BusCopyWith<$Res> {
  factory _$$BusImplCopyWith(_$BusImpl value, $Res Function(_$BusImpl) then) =
      __$$BusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String plate,
    int kmCurrent,
    DateTime? lastServiceAt,
    String? alias,
    String? notes,
  });
}

/// @nodoc
class __$$BusImplCopyWithImpl<$Res> extends _$BusCopyWithImpl<$Res, _$BusImpl>
    implements _$$BusImplCopyWith<$Res> {
  __$$BusImplCopyWithImpl(_$BusImpl _value, $Res Function(_$BusImpl) _then)
    : super(_value, _then);

  /// Create a copy of Bus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? plate = null,
    Object? kmCurrent = null,
    Object? lastServiceAt = freezed,
    Object? alias = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$BusImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        plate: null == plate
            ? _value.plate
            : plate // ignore: cast_nullable_to_non_nullable
                  as String,
        kmCurrent: null == kmCurrent
            ? _value.kmCurrent
            : kmCurrent // ignore: cast_nullable_to_non_nullable
                  as int,
        lastServiceAt: freezed == lastServiceAt
            ? _value.lastServiceAt
            : lastServiceAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        alias: freezed == alias
            ? _value.alias
            : alias // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BusImpl implements _Bus {
  const _$BusImpl({
    required this.id,
    required this.plate,
    this.kmCurrent = 0,
    this.lastServiceAt,
    this.alias,
    this.notes,
  });

  factory _$BusImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusImplFromJson(json);

  @override
  final String id;
  @override
  final String plate;
  @override
  @JsonKey()
  final int kmCurrent;
  @override
  final DateTime? lastServiceAt;
  @override
  final String? alias;
  @override
  final String? notes;

  @override
  String toString() {
    return 'Bus(id: $id, plate: $plate, kmCurrent: $kmCurrent, lastServiceAt: $lastServiceAt, alias: $alias, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.plate, plate) || other.plate == plate) &&
            (identical(other.kmCurrent, kmCurrent) ||
                other.kmCurrent == kmCurrent) &&
            (identical(other.lastServiceAt, lastServiceAt) ||
                other.lastServiceAt == lastServiceAt) &&
            (identical(other.alias, alias) || other.alias == alias) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    plate,
    kmCurrent,
    lastServiceAt,
    alias,
    notes,
  );

  /// Create a copy of Bus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusImplCopyWith<_$BusImpl> get copyWith =>
      __$$BusImplCopyWithImpl<_$BusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusImplToJson(this);
  }
}

abstract class _Bus implements Bus {
  const factory _Bus({
    required final String id,
    required final String plate,
    final int kmCurrent,
    final DateTime? lastServiceAt,
    final String? alias,
    final String? notes,
  }) = _$BusImpl;

  factory _Bus.fromJson(Map<String, dynamic> json) = _$BusImpl.fromJson;

  @override
  String get id;
  @override
  String get plate;
  @override
  int get kmCurrent;
  @override
  DateTime? get lastServiceAt;
  @override
  String? get alias;
  @override
  String? get notes;

  /// Create a copy of Bus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusImplCopyWith<_$BusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
