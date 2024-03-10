// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:piu_util/domain/entities/chart_data.dart';

import '../enum/chart_type.dart';

part 'clear_data.freezed.dart';
part 'clear_data.g.dart';

@freezed
class ClearData with _$ClearData {
  const factory ClearData({
    required int level,
    required ChartType type,
    required List<ChartData> chartData,
  }) = _ClearData;

  factory ClearData.fromJson(Map<String, Object?> json) => _$ClearDataFromJson(json);
}
