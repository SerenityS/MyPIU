import 'package:freezed_annotation/freezed_annotation.dart';

part 'play_data.freezed.dart';
part 'play_data.g.dart';

@freezed
class PlayData with _$PlayData {
  const factory PlayData({
    required int playCount,
    required int level,
    required int rating,
    required int clearCount,
    required int totalCount,
    required int pgNum,
    required int ugNum,
    required int egNum,
    required int sgNum,
    required int mgNum,
    required int tgNum,
    required int fgNum,
    required int rgNum,
  }) = _PlayData;

  factory PlayData.fromJson(Map<String, Object?> json) => _$PlayDataFromJson(json);
}
