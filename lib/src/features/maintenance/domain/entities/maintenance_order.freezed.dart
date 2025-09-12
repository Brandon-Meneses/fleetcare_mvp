// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MaintenanceOrder _$MaintenanceOrderFromJson(Map<String, dynamic> json) {
  return _MaintenanceOrder.fromJson(json);
}

/// @nodoc
mixin _$MaintenanceOrder {
  String get id => throw _privateConstructorUsedError;
  String get busId => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: MaintenanceStatus.planned)
  MaintenanceStatus get status => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: MaintenanceType.preventive)
  MaintenanceType get type => throw _privateConstructorUsedError;
  DateTime? get plannedAt => throw _privateConstructorUsedError;
  DateTime? get openedAt => throw _privateConstructorUsedError;
  DateTime? get closedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this MaintenanceOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MaintenanceOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaintenanceOrderCopyWith<MaintenanceOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaintenanceOrderCopyWith<$Res> {
  factory $MaintenanceOrderCopyWith(
    MaintenanceOrder value,
    $Res Function(MaintenanceOrder) then,
  ) = _$MaintenanceOrderCopyWithImpl<$Res, MaintenanceOrder>;
  @useResult
  $Res call({
    String id,
    String busId,
    @JsonKey(unknownEnumValue: MaintenanceStatus.planned)
    MaintenanceStatus status,
    @JsonKey(unknownEnumValue: MaintenanceType.preventive) MaintenanceType type,
    DateTime? plannedAt,
    DateTime? openedAt,
    DateTime? closedAt,
    String? notes,
  });
}

/// @nodoc
class _$MaintenanceOrderCopyWithImpl<$Res, $Val extends MaintenanceOrder>
    implements $MaintenanceOrderCopyWith<$Res> {
  _$MaintenanceOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaintenanceOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? busId = null,
    Object? status = null,
    Object? type = null,
    Object? plannedAt = freezed,
    Object? openedAt = freezed,
    Object? closedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            busId: null == busId
                ? _value.busId
                : busId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as MaintenanceStatus,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as MaintenanceType,
            plannedAt: freezed == plannedAt
                ? _value.plannedAt
                : plannedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            openedAt: freezed == openedAt
                ? _value.openedAt
                : openedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            closedAt: freezed == closedAt
                ? _value.closedAt
                : closedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
abstract class _$$MaintenanceOrderImplCopyWith<$Res>
    implements $MaintenanceOrderCopyWith<$Res> {
  factory _$$MaintenanceOrderImplCopyWith(
    _$MaintenanceOrderImpl value,
    $Res Function(_$MaintenanceOrderImpl) then,
  ) = __$$MaintenanceOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String busId,
    @JsonKey(unknownEnumValue: MaintenanceStatus.planned)
    MaintenanceStatus status,
    @JsonKey(unknownEnumValue: MaintenanceType.preventive) MaintenanceType type,
    DateTime? plannedAt,
    DateTime? openedAt,
    DateTime? closedAt,
    String? notes,
  });
}

/// @nodoc
class __$$MaintenanceOrderImplCopyWithImpl<$Res>
    extends _$MaintenanceOrderCopyWithImpl<$Res, _$MaintenanceOrderImpl>
    implements _$$MaintenanceOrderImplCopyWith<$Res> {
  __$$MaintenanceOrderImplCopyWithImpl(
    _$MaintenanceOrderImpl _value,
    $Res Function(_$MaintenanceOrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MaintenanceOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? busId = null,
    Object? status = null,
    Object? type = null,
    Object? plannedAt = freezed,
    Object? openedAt = freezed,
    Object? closedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$MaintenanceOrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        busId: null == busId
            ? _value.busId
            : busId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as MaintenanceStatus,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as MaintenanceType,
        plannedAt: freezed == plannedAt
            ? _value.plannedAt
            : plannedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        openedAt: freezed == openedAt
            ? _value.openedAt
            : openedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        closedAt: freezed == closedAt
            ? _value.closedAt
            : closedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$MaintenanceOrderImpl implements _MaintenanceOrder {
  const _$MaintenanceOrderImpl({
    required this.id,
    required this.busId,
    @JsonKey(unknownEnumValue: MaintenanceStatus.planned) required this.status,
    @JsonKey(unknownEnumValue: MaintenanceType.preventive) required this.type,
    this.plannedAt,
    this.openedAt,
    this.closedAt,
    this.notes,
  });

  factory _$MaintenanceOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$MaintenanceOrderImplFromJson(json);

  @override
  final String id;
  @override
  final String busId;
  @override
  @JsonKey(unknownEnumValue: MaintenanceStatus.planned)
  final MaintenanceStatus status;
  @override
  @JsonKey(unknownEnumValue: MaintenanceType.preventive)
  final MaintenanceType type;
  @override
  final DateTime? plannedAt;
  @override
  final DateTime? openedAt;
  @override
  final DateTime? closedAt;
  @override
  final String? notes;

  @override
  String toString() {
    return 'MaintenanceOrder(id: $id, busId: $busId, status: $status, type: $type, plannedAt: $plannedAt, openedAt: $openedAt, closedAt: $closedAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaintenanceOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.busId, busId) || other.busId == busId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.plannedAt, plannedAt) ||
                other.plannedAt == plannedAt) &&
            (identical(other.openedAt, openedAt) ||
                other.openedAt == openedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    busId,
    status,
    type,
    plannedAt,
    openedAt,
    closedAt,
    notes,
  );

  /// Create a copy of MaintenanceOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaintenanceOrderImplCopyWith<_$MaintenanceOrderImpl> get copyWith =>
      __$$MaintenanceOrderImplCopyWithImpl<_$MaintenanceOrderImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MaintenanceOrderImplToJson(this);
  }
}

abstract class _MaintenanceOrder implements MaintenanceOrder {
  const factory _MaintenanceOrder({
    required final String id,
    required final String busId,
    @JsonKey(unknownEnumValue: MaintenanceStatus.planned)
    required final MaintenanceStatus status,
    @JsonKey(unknownEnumValue: MaintenanceType.preventive)
    required final MaintenanceType type,
    final DateTime? plannedAt,
    final DateTime? openedAt,
    final DateTime? closedAt,
    final String? notes,
  }) = _$MaintenanceOrderImpl;

  factory _MaintenanceOrder.fromJson(Map<String, dynamic> json) =
      _$MaintenanceOrderImpl.fromJson;

  @override
  String get id;
  @override
  String get busId;
  @override
  @JsonKey(unknownEnumValue: MaintenanceStatus.planned)
  MaintenanceStatus get status;
  @override
  @JsonKey(unknownEnumValue: MaintenanceType.preventive)
  MaintenanceType get type;
  @override
  DateTime? get plannedAt;
  @override
  DateTime? get openedAt;
  @override
  DateTime? get closedAt;
  @override
  String? get notes;

  /// Create a copy of MaintenanceOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaintenanceOrderImplCopyWith<_$MaintenanceOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
