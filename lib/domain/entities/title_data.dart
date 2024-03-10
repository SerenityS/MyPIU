import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/title_type.dart';

part 'title_data.freezed.dart';
part 'title_data.g.dart';

@freezed
class TitleData with _$TitleData {
  const factory TitleData({
    String? id,
    required String titleText,
    required TitleType titleType,
    required String description,
    required bool hasTitle,
    required bool isEnable,
  }) = _TitleData;

  factory TitleData.fromJson(Map<String, Object?> json) => _$TitleDataFromJson(json);
}
