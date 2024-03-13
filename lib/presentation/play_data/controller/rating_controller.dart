import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/entities/rating_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';

import 'play_data_controller.dart';

class RatingController extends GetxController {
  final List<int> singleChartCount = List<int>.generate(28, (index) => 0);
  final List<int> doubleChartCount = List<int>.generate(28, (index) => 0);
  final List<int> coopChartCount = List<int>.generate(5, (index) => 0);

  final RxList<RatingData> ratingDataList = <RatingData>[].obs;
  final RxList<int> coopRatingDataList = RxList<int>.generate(5, (index) => 0);

  @override
  void onInit() async {
    super.onInit();

    await getChartCount();
    getClearData();

    ever(Get.find<PlayDataController>().bestScoreDataList, (_) {
      getClearData();
    });
  }

  Future<void> getChartCount() async {
    var countJson = await rootBundle.loadString('assets/json/level_count.json');
    var countList = json.decode(countJson);

    for (int i = 0; i < 28; i++) {
      try {
        singleChartCount[i] = countList["SINGLE"]["${i + 1}"];
      } catch (e) {
        continue;
      }
    }

    for (int i = 0; i < 28; i++) {
      try {
        doubleChartCount[i] = countList["DOUBLE"]["${i + 1}"];
      } catch (e) {
        continue;
      }
    }

    for (int i = 0; i < 5; i++) {
      try {
        coopChartCount[i] = countList["COOP"]["${i + 1}"];
      } catch (e) {
        continue;
      }
    }
  }

  void getClearData() {
    List<ChartData> clearData = Get.find<PlayDataController>().bestScoreDataList;

    ratingDataList.value = List<RatingData>.generate(28, (index) => RatingData(index + 1, 0, 0, 0, 0));
    coopRatingDataList.value = List<int>.generate(5, (index) => 0);

    for (var data in clearData) {
      if (data.chartType == ChartType.SINGLE) {
        ratingDataList[data.level - 1].clearData.add(data);
        ratingDataList[data.level - 1].singleCount++;
        ratingDataList[data.level - 1].singleRating += calcRating(data);
      } else if (data.chartType == ChartType.DOUBLE) {
        ratingDataList[data.level - 1].clearData.add(data);
        ratingDataList[data.level - 1].doubleCount++;
        ratingDataList[data.level - 1].doubleRating += calcRating(data);
      } else if (data.chartType == ChartType.COOP) {
        coopRatingDataList[data.level - 1] += calcRating(data);
      }
    }
  }

  int calcRating(ChartData data) {
    int levelPrefix = 100;

    for (int i = 0; i <= data.level - 10; i++) {
      levelPrefix += 10 * i;
    }

    return (levelPrefix * data.gradeType.ratingPrefix).round();
  }
}
