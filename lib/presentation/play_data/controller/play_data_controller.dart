import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/entities/play_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/usecases/play_data_usecases.dart';

class PlayDataController extends GetxController {
  final PlayDataUseCases _useCases = Get.find<PlayDataUseCases>();
  RxBool isLoading = false.obs;

  Rx<ChartType> currentChartType = ChartType.DOUBLE.obs;
  RxInt currentLevel = 24.obs;

  RxList<ChartData> clearDataList = <ChartData>[].obs;
  RxList<PlayData> playDataList = <PlayData>[].obs;

  @override
  void onInit() async {
    super.onInit();

    await getLevelData();
    await getClearData();

    ever(currentLevel, (_) async {
      await getClearData();
    });

    ever(currentChartType, (_) async {
      await getClearData();
    });
  }

  Future<void> getLevelData() async {
    // Get Chart Data from JSON
    var jsonString = await rootBundle.loadString('assets/json/${currentChartType.value.name}_$currentLevel.json');
    clearDataList.assignAll((json.decode(jsonString) as List).map((e) => ChartData.fromJson(e)).toList());
  }

  Future<void> getClearData() async {
    if (isLoading.value) return;
    isLoading.value = true;

    // Get Chart Data from JSON
    var jsonString = await rootBundle.loadString('assets/json/${currentChartType.value.name}_$currentLevel.json');
    List<ChartData> chartDataList = (json.decode(jsonString) as List).map((e) => ChartData.fromJson(e)).toList();

    // Get Best Score Data
    List<ChartData> scoreDataList = await _useCases.getBestScore.execute(currentLevel.value);

    // Generate Clear Data
    List<ChartData> generatedList = [];

    for (var chartData in chartDataList) {
      var matchingData = scoreDataList.firstWhereOrNull(
        (clearData) => clearData.title == chartData.title && clearData.chartType == chartData.chartType,
      );

      if (matchingData != null) {
        generatedList.add(
          ChartData(
            title: chartData.title,
            level: matchingData.level,
            score: matchingData.score,
            chartType: matchingData.chartType,
            gradeType: matchingData.gradeType,
            plateType: matchingData.plateType,
            jacketFileName: chartData.jacketFileName,
          ),
        );
      } else {
        generatedList.add(chartData);
      }
    }

    generatedList.sort((a, b) => b.score.compareTo(a.score));
    clearDataList.assignAll(generatedList);

    isLoading.value = false;
  }

  Future<void> getPlayData() async {
    playDataList.assignAll(await _useCases.getPlayData.execute(currentLevel.value));
  }
}
