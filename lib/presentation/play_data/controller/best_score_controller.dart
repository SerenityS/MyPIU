import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/enum/grade_type.dart';
import 'package:piu_util/domain/enum/plate_type.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'play_data_controller.dart';

class BestScoreController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  SfRangeValues rangeValues = const SfRangeValues(28.0, 0.0);
  RxInt minLevel = 28.obs;
  RxInt maxLevel = 0.obs;

  RxList<ChartType> chartTypeList = <ChartType>[ChartType.SINGLE, ChartType.DOUBLE].obs;
  RxList<GradeType> gradeTypeList = GradeType.values.where((e) => e.index >= GradeType.SSSp.index).toList().obs;
  RxList<PlateType> plateTypeList = PlateType.values.map((e) => e).toList().obs;

  RxList<ChartData> bestScoreDataList = <ChartData>[].obs;
  RxList<ChartData> filterBestScoreDataList = <ChartData>[].obs;

  @override
  void onInit() {
    super.onInit();

    for (int i = GradeType.SSSp.index; i <= GradeType.F.index; i++) {
      gradeTypeList.add(GradeType.values[i]);
    }

    bestScoreDataList.assignAll(Get.find<PlayDataController>().bestScoreDataList);
    filterBestScoreDataList.assignAll(bestScoreDataList);

    for (var element in bestScoreDataList) {
      if (maxLevel.value < element.level) {
        maxLevel.value = element.level;
      } else if (minLevel.value > element.level) {
        minLevel.value = element.level;
      }
    }

    rangeValues = SfRangeValues(minLevel.value.toDouble(), maxLevel.value.toDouble());

    ever(Get.find<PlayDataController>().bestScoreDataList, (_) {
      bestScoreDataList.assignAll(Get.find<PlayDataController>().bestScoreDataList);
    });
    ever(chartTypeList, (_) => filterBestScoreData());
    ever(gradeTypeList, (_) => filterBestScoreData());
    ever(plateTypeList, (_) => filterBestScoreData());
  }

  void filterBestScoreData() {
    filterBestScoreDataList.assignAll(
      bestScoreDataList.where(
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

          if (rangeValues.start > element.level || rangeValues.end < element.level) {
            return false;
          }

          return true;
        },
      ).toList(),
    );
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
