import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/chart_type.dart';
import '../enum/grade_type.dart';
import '../enum/plate_type.dart';

part 'chart_data.freezed.dart';
part 'chart_data.g.dart';

@freezed
class ChartData with _$ChartData {
  const factory ChartData({
    required String title,
    required int level,
    @Default(0) int score,
    required ChartType chartType,
    @Default(GradeType.C) GradeType gradeType,
    @Default(PlateType.RG) PlateType plateType,
    @Default("") String jacketFileName,
  }) = _ChartData;

  factory ChartData.fromJson(Map<String, Object?> json) => _$ChartDataFromJson(json);
}
