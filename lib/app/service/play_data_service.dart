import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:piu_util/data/datasources/local/play_data_local_data_source.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/usecases/play_data_usecases.dart';

class PlayDataService extends GetxService {
  static PlayDataService get to => Get.find();

  final PlayDataUseCases _useCases = Get.find<PlayDataUseCases>();
  final PlayDataLocalDataSource _playDataSource = PlayDataLocalDataSource();

  final RxInt totalPageIndex = 0.obs;
  final RxInt currentLoadingPageIndex = 0.obs;

  final RxList<ChartData> singleLevelDataList = <ChartData>[].obs;
  final RxList<ChartData> doubleLevelDataList = <ChartData>[].obs;

  final RxList<ChartData> clearDataList = <ChartData>[].obs;

  Future<void> getClearDataFromRemote() async {
    if (totalPageIndex.value != 0) return;

    try {
      clearDataList.assignAll(await _useCases.getClearData.execute());
      await _playDataSource.saveClearData(clearDataList);
    } catch (e) {
      clearDataList.assignAll([]);
    }
  }

  void getClearDataFromLocal() {
    final List<ChartData>? clearData = _playDataSource.getClearData();

    if (clearData != null) {
      clearDataList.assignAll(clearData);
    }
  }

  Future<void> setLevelData(int level) async {
    // Get Chart Data from JSON
    try {
      var singleJsonString = await rootBundle.loadString('assets/json/SINGLE_$level.json');

      singleLevelDataList.assignAll((json.decode(singleJsonString) as List).map((e) => ChartData.fromJson(e)).toList());
    } catch (e) {
      singleLevelDataList.assignAll([]);
    }

    try {
      var doubleJsonString = await rootBundle.loadString('assets/json/DOUBLE_$level.json');

      doubleLevelDataList.assignAll((json.decode(doubleJsonString) as List).map((e) => ChartData.fromJson(e)).toList());
    } catch (e) {
      doubleLevelDataList.assignAll([]);
    }
  }

  Future<List<ChartData>> generateDataList(ChartType chartType) async {
    List<ChartData> levelDataList = [];

    if (chartType == ChartType.SINGLE) {
      levelDataList.assignAll(singleLevelDataList);
    } else if (chartType == ChartType.DOUBLE) {
      levelDataList.assignAll(doubleLevelDataList);
    }

    List<ChartData> generatedData = [];
    for (var chartData in levelDataList) {
      var matchingData = clearDataList.firstWhereOrNull(
        (clearData) => clearData.title == chartData.title && clearData.level == chartData.level && clearData.chartType == chartType,
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

    return generatedData;
  }
}
