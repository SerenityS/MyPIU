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
  RxList<ChartData> bestScoreDataList = <ChartData>[].obs;
  RxList<ChartData> levelDataList = <ChartData>[].obs;

  RxList<PlayData> playDataList = <PlayData>[].obs;

  @override
  void onInit() async {
    super.onInit();

    await getBestScoreData();
    await generateClearData();

    ever(currentLevel, (_) async {
      await generateClearData();
    });

    ever(currentChartType, (_) async {
      await generateClearData();
    });
  }

  Future<void> getLevelData() async {
    // Get Chart Data from JSON
    var jsonString = await rootBundle.loadString('assets/json/${currentChartType.value.name}_$currentLevel.json');
    levelDataList.assignAll((json.decode(jsonString) as List).map((e) => ChartData.fromJson(e)).toList());
  }

  Future<void> getBestScoreData() async {
    // Get Best Score Data from web
    bestScoreDataList.assignAll(await _useCases.getBestScore.execute());
  }

  Future<void> generateClearData() async {
    await getLevelData();

    // Generate Clear Data
    List<ChartData> generatedData = [];

    for (var chartData in levelDataList) {
      var matchingData = bestScoreDataList.firstWhereOrNull(
        (clearData) =>
            clearData.title == chartData.title && clearData.level == chartData.level && clearData.chartType == chartData.chartType,
      );

      if (matchingData != null) {
        generatedData.add(
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
        generatedData.add(chartData);
      }
    }

    generatedData.sort((a, b) => b.score.compareTo(a.score));
    clearDataList.assignAll(generatedData);
  }

  Future<void> getPlayData() async {
    playDataList.assignAll(await _useCases.getPlayData.execute(currentLevel.value));
  }
}
