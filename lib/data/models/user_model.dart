import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User Model - Migrated from Android UserManagement.java
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String username,
    required String name,
    required String mobile,
    @JsonKey(name: 'user_type') required String userType,
    required String designation,
    @JsonKey(name: 'profile_photo_link') String? profilePhotoLink,
    String? address,
    @JsonKey(name: 'division_name') String? divisionName,
    @JsonKey(name: 'division_id') int? divisionId,
    @JsonKey(name: 'sub_division_name') String? subDivisionName,
    @JsonKey(name: 'sub_division_id') int? subDivisionId,
    @JsonKey(name: 'circle_name') String? circleName,
    @JsonKey(name: 'circle_id') int? circleId,
    @JsonKey(name: 'first_time_login') @Default(false) bool firstTimeLogin,
    String? token,
    @JsonKey(name: 'refresh_token') String? refreshToken,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Role helpers
  bool get isSE => userType == 'se';
  bool get isEE => userType == 'ee';
  bool get isAEE => userType == 'aee';
  bool get isJE => userType == 'je';
  bool get isAE => userType == 'ae';
  bool get isVendor => userType == 'vendor';
  bool get isFieldEngineer => isJE || isAE;
  bool get isEngineer => isSE || isEE || isAEE;
}
