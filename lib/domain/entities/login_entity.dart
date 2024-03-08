// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_entity.freezed.dart';
part 'login_entity.g.dart';

@freezed
class LoginEntity with _$LoginEntity {
  const factory LoginEntity({
    @Default("/") String url,
    @JsonKey(name: "mb_id") required String email,
    @JsonKey(name: "mb_password") required String password,
  }) = _LoginEntity;

  factory LoginEntity.fromJson(Map<String, Object?> json) => _$LoginEntityFromJson(json);
}
