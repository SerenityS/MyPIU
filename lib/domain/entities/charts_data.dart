import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/chart_type.dart';

part 'charts_data.freezed.dart';
part 'charts_data.g.dart';

@freezed
class ChartsData with _$ChartsData {
  const factory ChartsData({
    required int level,
    required ChartType type,
    required List<Songs> songs,
  }) = _ChartsData;

  factory ChartsData.fromJson(Map<String, Object?> json) => _$ChartsDataFromJson(json);
}

@freezed
class Songs with _$Songs {
  const factory Songs({
    required String title,
    required String artist,
    required String jacketFileName,
  }) = _Songs;

  factory Songs.fromJson(Map<String, Object?> json) => _$SongsFromJson(json);
}
