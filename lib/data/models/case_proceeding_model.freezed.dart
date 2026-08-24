// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'case_proceeding_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CaseProceedingModel _$CaseProceedingModelFromJson(Map<String, dynamic> json) {
  return _CaseProceedingModel.fromJson(json);
}

/// @nodoc
mixin _$CaseProceedingModel {
  String get task => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String get userName => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_designation')
  String? get userDesignation => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get remarks => throw _privateConstructorUsedError;

  /// Serializes this CaseProceedingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CaseProceedingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CaseProceedingModelCopyWith<CaseProceedingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CaseProceedingModelCopyWith<$Res> {
  factory $CaseProceedingModelCopyWith(
    CaseProceedingModel value,
    $Res Function(CaseProceedingModel) then,
  ) = _$CaseProceedingModelCopyWithImpl<$Res, CaseProceedingModel>;
  @useResult
  $Res call({
    String task,
    @JsonKey(name: 'user_name') String userName,
    @JsonKey(name: 'user_designation') String? userDesignation,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String? remarks,
  });
}

/// @nodoc
class _$CaseProceedingModelCopyWithImpl<$Res, $Val extends CaseProceedingModel>
    implements $CaseProceedingModelCopyWith<$Res> {
  _$CaseProceedingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CaseProceedingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? task = null,
    Object? userName = null,
    Object? userDesignation = freezed,
    Object? createdAt = null,
    Object? remarks = freezed,
  }) {
    return _then(
      _value.copyWith(
            task: null == task
                ? _value.task
                : task // ignore: cast_nullable_to_non_nullable
                      as String,
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            userDesignation: freezed == userDesignation
                ? _value.userDesignation
                : userDesignation // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            remarks: freezed == remarks
                ? _value.remarks
                : remarks // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CaseProceedingModelImplCopyWith<$Res>
    implements $CaseProceedingModelCopyWith<$Res> {
  factory _$$CaseProceedingModelImplCopyWith(
    _$CaseProceedingModelImpl value,
    $Res Function(_$CaseProceedingModelImpl) then,
  ) = __$$CaseProceedingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String task,
    @JsonKey(name: 'user_name') String userName,
    @JsonKey(name: 'user_designation') String? userDesignation,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String? remarks,
  });
}

/// @nodoc
class __$$CaseProceedingModelImplCopyWithImpl<$Res>
    extends _$CaseProceedingModelCopyWithImpl<$Res, _$CaseProceedingModelImpl>
    implements _$$CaseProceedingModelImplCopyWith<$Res> {
  __$$CaseProceedingModelImplCopyWithImpl(
    _$CaseProceedingModelImpl _value,
    $Res Function(_$CaseProceedingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CaseProceedingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? task = null,
    Object? userName = null,
    Object? userDesignation = freezed,
    Object? createdAt = null,
    Object? remarks = freezed,
  }) {
    return _then(
      _$CaseProceedingModelImpl(
        task: null == task
            ? _value.task
            : task // ignore: cast_nullable_to_non_nullable
                  as String,
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        userDesignation: freezed == userDesignation
            ? _value.userDesignation
            : userDesignation // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        remarks: freezed == remarks
            ? _value.remarks
            : remarks // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CaseProceedingModelImpl implements _CaseProceedingModel {
  const _$CaseProceedingModelImpl({
    required this.task,
    @JsonKey(name: 'user_name') required this.userName,
    @JsonKey(name: 'user_designation') this.userDesignation,
    @JsonKey(name: 'created_at') required this.createdAt,
    this.remarks,
  });

  factory _$CaseProceedingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CaseProceedingModelImplFromJson(json);

  @override
  final String task;
  @override
  @JsonKey(name: 'user_name')
  final String userName;
  @override
  @JsonKey(name: 'user_designation')
  final String? userDesignation;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  final String? remarks;

  @override
  String toString() {
    return 'CaseProceedingModel(task: $task, userName: $userName, userDesignation: $userDesignation, createdAt: $createdAt, remarks: $remarks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CaseProceedingModelImpl &&
            (identical(other.task, task) || other.task == task) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userDesignation, userDesignation) ||
                other.userDesignation == userDesignation) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.remarks, remarks) || other.remarks == remarks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    task,
    userName,
    userDesignation,
    createdAt,
    remarks,
  );

  /// Create a copy of CaseProceedingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CaseProceedingModelImplCopyWith<_$CaseProceedingModelImpl> get copyWith =>
      __$$CaseProceedingModelImplCopyWithImpl<_$CaseProceedingModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CaseProceedingModelImplToJson(this);
  }
}

abstract class _CaseProceedingModel implements CaseProceedingModel {
  const factory _CaseProceedingModel({
    required final String task,
    @JsonKey(name: 'user_name') required final String userName,
    @JsonKey(name: 'user_designation') final String? userDesignation,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    final String? remarks,
  }) = _$CaseProceedingModelImpl;

  factory _CaseProceedingModel.fromJson(Map<String, dynamic> json) =
      _$CaseProceedingModelImpl.fromJson;

  @override
  String get task;
  @override
  @JsonKey(name: 'user_name')
  String get userName;
  @override
  @JsonKey(name: 'user_designation')
  String? get userDesignation;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  String? get remarks;

  /// Create a copy of CaseProceedingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CaseProceedingModelImplCopyWith<_$CaseProceedingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
