import 'package:freezed_annotation/freezed_annotation.dart';

part 'avatar_data.freezed.dart';
part 'avatar_data.g.dart';

@freezed
class AvatarData with _$AvatarData {
  const factory AvatarData({
    String? id,
    required String name,
    required String fileName,
    @Default(0) int requiredCoin,
    required String status,
    required bool isEnable,
  }) = _AvatarData;

  factory AvatarData.fromJson(Map<String, Object?> json) => _$AvatarDataFromJson(json);
}
