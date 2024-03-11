import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/enum/grade_type.dart';
import 'package:piu_util/domain/enum/plate_type.dart';

part 'recently_play_data.freezed.dart';
part 'recently_play_data.g.dart';

@freezed
class RecentlyPlayData with _$RecentlyPlayData {
  const factory RecentlyPlayData({
    required String title,
    required String jacketFileName,
    required int level,
    required ChartType chartType,
    GradeType? gradeType,
    int? score,
    PlateType? plateType,
    required int perfect,
    required int great,
    required int good,
    required int bad,
    required int miss,
    required DateTime playDate,
  }) = _RecentlyPlayData;

  factory RecentlyPlayData.fromJson(Map<String, Object?> json) => _$RecentlyPlayDataFromJson(json);
}
