import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/service/play_data_service.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/enum/grade_type.dart';
import 'package:piu_util/domain/enum/plate_type.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BestScoreViewModel extends GetxController {
  // Clear Data
  List<ChartData> get clearDataList => PlayDataService.to.clearDataList;
  RxList<ChartData> filterBestScoreDataList = <ChartData>[].obs;

  // Filter
  final TextEditingController searchController = TextEditingController();

  Rx<SfRangeValues> rangeValues = const SfRangeValues(28.0, 0.0).obs;
  RxInt minLevel = 28.obs;
  RxInt maxLevel = 0.obs;

  RxList<ChartType> chartTypeList = <ChartType>[ChartType.SINGLE, ChartType.DOUBLE].obs;
  RxList<GradeType> gradeTypeList = GradeType.values.map((e) => e).toList().obs;
  RxList<PlateType> plateTypeList = PlateType.values.map((e) => e).toList().obs;

  @override
  void onInit() {
    super.onInit();

    filterBestScoreDataList.assignAll(PlayDataService.to.clearDataList);
    _setClearLevel();

    _listenChanges();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _listenChanges() {
    ever(chartTypeList, (_) => filterBestScoreData());
    ever(gradeTypeList, (_) => filterBestScoreData());
    ever(plateTypeList, (_) => filterBestScoreData());
    ever(rangeValues, (_) => filterBestScoreData());
  }

  void filterBestScoreData() {
    filterBestScoreDataList.assignAll(
      clearDataList.where(
        (element) {
          if (searchController.text.isNotEmpty &&
              !element.title.replaceAll(" ", "").toLowerCase().contains(searchController.text.replaceAll(" ", "").toLowerCase())) {
            return false;
          }

          if (chartTypeList.isNotEmpty && !chartTypeList.contains(element.chartType)) {
            return false;
          }

          if (gradeTypeList.isNotEmpty && !gradeTypeList.contains(element.gradeType)) {
            return false;
          }

          if (plateTypeList.isNotEmpty && !plateTypeList.contains(element.plateType)) {
            return false;
          }

          if (rangeValues.value.start > element.level || rangeValues.value.end < element.level) {
            return false;
          }

          return true;
        },
      ).toList(),
    );
  }

  void _setClearLevel() {
    minLevel.value = clearDataList.fold<int>(28, (lowest, element) => lowest < element.level ? lowest : element.level);
    maxLevel.value = clearDataList.fold<int>(0, (highest, element) => highest > element.level ? highest : element.level);
    rangeValues.value = SfRangeValues(minLevel.value.toDouble(), maxLevel.value.toDouble());
  }

  void toggleChartType(ChartType chartType) {
    if (chartTypeList.contains(chartType)) {
      chartTypeList.remove(chartType);
    } else {
      chartTypeList.add(chartType);
    }
    chartTypeList.refresh();
  }

  void toggleGradeType(GradeType gradeType) {
    if (gradeType == GradeType.A) {
      if (gradeTypeList.contains(GradeType.A)) {
        for (int i = GradeType.A.index; i <= GradeType.F.index; i++) {
          gradeTypeList.remove(GradeType.values[i]);
        }
      } else {
        for (int i = GradeType.A.index; i <= GradeType.F.index; i++) {
          gradeTypeList.add(GradeType.values[i]);
        }
      }

      return;
    }

    if (gradeTypeList.contains(gradeType)) {
      gradeTypeList.remove(gradeType);
    } else {
      gradeTypeList.add(gradeType);
    }
    gradeTypeList.refresh();
  }

  void togglePlateType(PlateType plateType) {
    if (plateTypeList.contains(plateType)) {
      plateTypeList.remove(plateType);
    } else {
      plateTypeList.add(plateType);
    }
    plateTypeList.refresh();
  }
}
