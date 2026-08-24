import 'package:freezed_annotation/freezed_annotation.dart';

part 'case_proceeding_model.freezed.dart';
part 'case_proceeding_model.g.dart';

@freezed
class CaseProceedingModel with _$CaseProceedingModel {
  const factory CaseProceedingModel({
    required String task,
    @JsonKey(name: 'user_name') required String userName,
    @JsonKey(name: 'user_designation') String? userDesignation,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    String? remarks,
  }) = _CaseProceedingModel;

  factory CaseProceedingModel.fromJson(Map<String, dynamic> json) =>
      _$CaseProceedingModelFromJson(json);
}
