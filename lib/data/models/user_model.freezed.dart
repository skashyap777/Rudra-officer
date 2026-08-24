// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  int get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get mobile => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_type')
  String get userType => throw _privateConstructorUsedError;
  String get designation => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_photo_link')
  String? get profilePhotoLink => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'division_name')
  String? get divisionName => throw _privateConstructorUsedError;
  @JsonKey(name: 'division_id')
  int? get divisionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'sub_division_name')
  String? get subDivisionName => throw _privateConstructorUsedError;
  @JsonKey(name: 'sub_division_id')
  int? get subDivisionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'circle_name')
  String? get circleName => throw _privateConstructorUsedError;
  @JsonKey(name: 'circle_id')
  int? get circleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_time_login')
  bool get firstTimeLogin => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String? get refreshToken => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    int id,
    String username,
    String name,
    String mobile,
    @JsonKey(name: 'user_type') String userType,
    String designation,
    @JsonKey(name: 'profile_photo_link') String? profilePhotoLink,
    String? address,
    @JsonKey(name: 'division_name') String? divisionName,
    @JsonKey(name: 'division_id') int? divisionId,
    @JsonKey(name: 'sub_division_name') String? subDivisionName,
    @JsonKey(name: 'sub_division_id') int? subDivisionId,
    @JsonKey(name: 'circle_name') String? circleName,
    @JsonKey(name: 'circle_id') int? circleId,
    @JsonKey(name: 'first_time_login') bool firstTimeLogin,
    String? token,
    @JsonKey(name: 'refresh_token') String? refreshToken,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? name = null,
    Object? mobile = null,
    Object? userType = null,
    Object? designation = null,
    Object? profilePhotoLink = freezed,
    Object? address = freezed,
    Object? divisionName = freezed,
    Object? divisionId = freezed,
    Object? subDivisionName = freezed,
    Object? subDivisionId = freezed,
    Object? circleName = freezed,
    Object? circleId = freezed,
    Object? firstTimeLogin = null,
    Object? token = freezed,
    Object? refreshToken = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            mobile: null == mobile
                ? _value.mobile
                : mobile // ignore: cast_nullable_to_non_nullable
                      as String,
            userType: null == userType
                ? _value.userType
                : userType // ignore: cast_nullable_to_non_nullable
                      as String,
            designation: null == designation
                ? _value.designation
                : designation // ignore: cast_nullable_to_non_nullable
                      as String,
            profilePhotoLink: freezed == profilePhotoLink
                ? _value.profilePhotoLink
                : profilePhotoLink // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            divisionName: freezed == divisionName
                ? _value.divisionName
                : divisionName // ignore: cast_nullable_to_non_nullable
                      as String?,
            divisionId: freezed == divisionId
                ? _value.divisionId
                : divisionId // ignore: cast_nullable_to_non_nullable
                      as int?,
            subDivisionName: freezed == subDivisionName
                ? _value.subDivisionName
                : subDivisionName // ignore: cast_nullable_to_non_nullable
                      as String?,
            subDivisionId: freezed == subDivisionId
                ? _value.subDivisionId
                : subDivisionId // ignore: cast_nullable_to_non_nullable
                      as int?,
            circleName: freezed == circleName
                ? _value.circleName
                : circleName // ignore: cast_nullable_to_non_nullable
                      as String?,
            circleId: freezed == circleId
                ? _value.circleId
                : circleId // ignore: cast_nullable_to_non_nullable
                      as int?,
            firstTimeLogin: null == firstTimeLogin
                ? _value.firstTimeLogin
                : firstTimeLogin // ignore: cast_nullable_to_non_nullable
                      as bool,
            token: freezed == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String?,
            refreshToken: freezed == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String username,
    String name,
    String mobile,
    @JsonKey(name: 'user_type') String userType,
    String designation,
    @JsonKey(name: 'profile_photo_link') String? profilePhotoLink,
    String? address,
    @JsonKey(name: 'division_name') String? divisionName,
    @JsonKey(name: 'division_id') int? divisionId,
    @JsonKey(name: 'sub_division_name') String? subDivisionName,
    @JsonKey(name: 'sub_division_id') int? subDivisionId,
    @JsonKey(name: 'circle_name') String? circleName,
    @JsonKey(name: 'circle_id') int? circleId,
    @JsonKey(name: 'first_time_login') bool firstTimeLogin,
    String? token,
    @JsonKey(name: 'refresh_token') String? refreshToken,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? name = null,
    Object? mobile = null,
    Object? userType = null,
    Object? designation = null,
    Object? profilePhotoLink = freezed,
    Object? address = freezed,
    Object? divisionName = freezed,
    Object? divisionId = freezed,
    Object? subDivisionName = freezed,
    Object? subDivisionId = freezed,
    Object? circleName = freezed,
    Object? circleId = freezed,
    Object? firstTimeLogin = null,
    Object? token = freezed,
    Object? refreshToken = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        mobile: null == mobile
            ? _value.mobile
            : mobile // ignore: cast_nullable_to_non_nullable
                  as String,
        userType: null == userType
            ? _value.userType
            : userType // ignore: cast_nullable_to_non_nullable
                  as String,
        designation: null == designation
            ? _value.designation
            : designation // ignore: cast_nullable_to_non_nullable
                  as String,
        profilePhotoLink: freezed == profilePhotoLink
            ? _value.profilePhotoLink
            : profilePhotoLink // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        divisionName: freezed == divisionName
            ? _value.divisionName
            : divisionName // ignore: cast_nullable_to_non_nullable
                  as String?,
        divisionId: freezed == divisionId
            ? _value.divisionId
            : divisionId // ignore: cast_nullable_to_non_nullable
                  as int?,
        subDivisionName: freezed == subDivisionName
            ? _value.subDivisionName
            : subDivisionName // ignore: cast_nullable_to_non_nullable
                  as String?,
        subDivisionId: freezed == subDivisionId
            ? _value.subDivisionId
            : subDivisionId // ignore: cast_nullable_to_non_nullable
                  as int?,
        circleName: freezed == circleName
            ? _value.circleName
            : circleName // ignore: cast_nullable_to_non_nullable
                  as String?,
        circleId: freezed == circleId
            ? _value.circleId
            : circleId // ignore: cast_nullable_to_non_nullable
                  as int?,
        firstTimeLogin: null == firstTimeLogin
            ? _value.firstTimeLogin
            : firstTimeLogin // ignore: cast_nullable_to_non_nullable
                  as bool,
        token: freezed == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String?,
        refreshToken: freezed == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.username,
    required this.name,
    required this.mobile,
    @JsonKey(name: 'user_type') required this.userType,
    required this.designation,
    @JsonKey(name: 'profile_photo_link') this.profilePhotoLink,
    this.address,
    @JsonKey(name: 'division_name') this.divisionName,
    @JsonKey(name: 'division_id') this.divisionId,
    @JsonKey(name: 'sub_division_name') this.subDivisionName,
    @JsonKey(name: 'sub_division_id') this.subDivisionId,
    @JsonKey(name: 'circle_name') this.circleName,
    @JsonKey(name: 'circle_id') this.circleId,
    @JsonKey(name: 'first_time_login') this.firstTimeLogin = false,
    this.token,
    @JsonKey(name: 'refresh_token') this.refreshToken,
  }) : super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final int id;
  @override
  final String username;
  @override
  final String name;
  @override
  final String mobile;
  @override
  @JsonKey(name: 'user_type')
  final String userType;
  @override
  final String designation;
  @override
  @JsonKey(name: 'profile_photo_link')
  final String? profilePhotoLink;
  @override
  final String? address;
  @override
  @JsonKey(name: 'division_name')
  final String? divisionName;
  @override
  @JsonKey(name: 'division_id')
  final int? divisionId;
  @override
  @JsonKey(name: 'sub_division_name')
  final String? subDivisionName;
  @override
  @JsonKey(name: 'sub_division_id')
  final int? subDivisionId;
  @override
  @JsonKey(name: 'circle_name')
  final String? circleName;
  @override
  @JsonKey(name: 'circle_id')
  final int? circleId;
  @override
  @JsonKey(name: 'first_time_login')
  final bool firstTimeLogin;
  @override
  final String? token;
  @override
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, name: $name, mobile: $mobile, userType: $userType, designation: $designation, profilePhotoLink: $profilePhotoLink, address: $address, divisionName: $divisionName, divisionId: $divisionId, subDivisionName: $subDivisionName, subDivisionId: $subDivisionId, circleName: $circleName, circleId: $circleId, firstTimeLogin: $firstTimeLogin, token: $token, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mobile, mobile) || other.mobile == mobile) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.designation, designation) ||
                other.designation == designation) &&
            (identical(other.profilePhotoLink, profilePhotoLink) ||
                other.profilePhotoLink == profilePhotoLink) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.divisionName, divisionName) ||
                other.divisionName == divisionName) &&
            (identical(other.divisionId, divisionId) ||
                other.divisionId == divisionId) &&
            (identical(other.subDivisionName, subDivisionName) ||
                other.subDivisionName == subDivisionName) &&
            (identical(other.subDivisionId, subDivisionId) ||
                other.subDivisionId == subDivisionId) &&
            (identical(other.circleName, circleName) ||
                other.circleName == circleName) &&
            (identical(other.circleId, circleId) ||
                other.circleId == circleId) &&
            (identical(other.firstTimeLogin, firstTimeLogin) ||
                other.firstTimeLogin == firstTimeLogin) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    username,
    name,
    mobile,
    userType,
    designation,
    profilePhotoLink,
    address,
    divisionName,
    divisionId,
    subDivisionName,
    subDivisionId,
    circleName,
    circleId,
    firstTimeLogin,
    token,
    refreshToken,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel({
    required final int id,
    required final String username,
    required final String name,
    required final String mobile,
    @JsonKey(name: 'user_type') required final String userType,
    required final String designation,
    @JsonKey(name: 'profile_photo_link') final String? profilePhotoLink,
    final String? address,
    @JsonKey(name: 'division_name') final String? divisionName,
    @JsonKey(name: 'division_id') final int? divisionId,
    @JsonKey(name: 'sub_division_name') final String? subDivisionName,
    @JsonKey(name: 'sub_division_id') final int? subDivisionId,
    @JsonKey(name: 'circle_name') final String? circleName,
    @JsonKey(name: 'circle_id') final int? circleId,
    @JsonKey(name: 'first_time_login') final bool firstTimeLogin,
    final String? token,
    @JsonKey(name: 'refresh_token') final String? refreshToken,
  }) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  int get id;
  @override
  String get username;
  @override
  String get name;
  @override
  String get mobile;
  @override
  @JsonKey(name: 'user_type')
  String get userType;
  @override
  String get designation;
  @override
  @JsonKey(name: 'profile_photo_link')
  String? get profilePhotoLink;
  @override
  String? get address;
  @override
  @JsonKey(name: 'division_name')
  String? get divisionName;
  @override
  @JsonKey(name: 'division_id')
  int? get divisionId;
  @override
  @JsonKey(name: 'sub_division_name')
  String? get subDivisionName;
  @override
  @JsonKey(name: 'sub_division_id')
  int? get subDivisionId;
  @override
  @JsonKey(name: 'circle_name')
  String? get circleName;
  @override
  @JsonKey(name: 'circle_id')
  int? get circleId;
  @override
  @JsonKey(name: 'first_time_login')
  bool get firstTimeLogin;
  @override
  String? get token;
  @override
  @JsonKey(name: 'refresh_token')
  String? get refreshToken;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
