import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:piu_util/data/datasources/local/play_data_local_data_source.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/entities/clear_data.dart';
import 'package:piu_util/domain/entities/play_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/usecases/play_data_usecases.dart';

class PlayDataController extends GetxController {
  final PlayDataUseCases _useCases = Get.find<PlayDataUseCases>();
  final PlayDataLocalDataSource _playDataSource = PlayDataLocalDataSource();
  RxBool isLoading = false.obs;

  Rx<ChartType> currentChartType = ChartType.DOUBLE.obs;
  RxInt currentLevel = 24.obs;

  RxList<ClearData> allClearDataList = <ClearData>[].obs;
  RxList<ChartData> levelDataList = <ChartData>[].obs;

  RxList<ChartData> clearDataList = <ChartData>[].obs;

  RxList<PlayData> playDataList = <PlayData>[].obs;

  @override
  void onInit() async {
    super.onInit();

    if (_playDataSource.getClearData() == null) {
      await getBestScoreData();
    } else {
      allClearDataList.assignAll(_playDataSource.getClearData()!);
      generateClearDataList();
    }

    ever(currentChartType, (_) => generateClearDataList());
    ever(currentLevel, (_) => generateClearDataList());
  }

  void generateClearDataList() {
    clearDataList.assignAll(allClearDataList
            .firstWhereOrNull((element) => element.level == currentLevel.value && element.type == currentChartType.value)
            ?.chartData ??
        []);
  }

  Future<void> getBestScoreData() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      // Get Best Score Data from web
      List<ChartData> bestScoreDataList = await _useCases.getBestScore.execute();

      for (int i = 0; i < ChartType.values.length; i++) {
        for (int j = 10; j <= 28; j++) {
          // Get Chart Data from JSON
          List<ChartData> levelDataLists = [];

          try {
            var jsonString = await rootBundle.loadString('assets/json/${ChartType.values[i].name}_$j.json');
            levelDataLists.assignAll((json.decode(jsonString) as List).map((e) => ChartData.fromJson(e)).toList());
          } catch (e) {
            continue;
          }

          // Generate Clear Data
          List<ChartData> generatedData = [];

          for (var chartData in levelDataLists) {
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
          allClearDataList.add(
            ClearData(
              level: j,
              type: ChartType.values[i],
              chartData: generatedData,
            ),
          );
        }
      }
      allClearDataList.refresh();
      await _playDataSource.saveClearData(allClearDataList);

      generateClearDataList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPlayData() async {
    playDataList.assignAll(await _useCases.getPlayData.execute(currentLevel.value));
  }
}
