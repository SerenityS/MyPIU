import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/title_type.dart';

part 'my_data.freezed.dart';
part 'my_data.g.dart';

@freezed
class MyData with _$MyData {
  const factory MyData({
    required int id,
    required String nickname,
    required String avatar,
    required TitleType titleType,
    required String titleText,
    required int coin,
    required String recentPlayDate,
    required String recentPlayPlace,
  }) = _MyData;

  factory MyData.fromJson(Map<String, Object?> json) => _$MyDataFromJson(json);
}
