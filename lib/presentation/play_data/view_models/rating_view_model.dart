import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/extension/calc_rating.dart';
import 'package:piu_util/app/service/play_data_service.dart';
import 'package:piu_util/domain/entities/rating_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';

class RatingViewModel extends GetxController {
  // Chart Count
  final List<int> singleChartCount = List<int>.generate(28, (index) => 0);
  final List<int> doubleChartCount = List<int>.generate(28, (index) => 0);
  final List<int> coopChartCount = List<int>.generate(5, (index) => 0);

  // Rating Data
  final RxList<RatingData> ratingDataList = <RatingData>[].obs;
  final RxList<int> coopRatingDataList = RxList<int>.generate(5, (index) => 0);

  @override
  void onInit() async {
    super.onInit();

    await _getChartCount();
    _generateRatingData();

    ever(PlayDataService.to.clearDataList, (_) => _generateRatingData());
  }

  Future<void> _getChartCount() async {
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

  void _generateRatingData() {
    ratingDataList.value = List<RatingData>.generate(28, (index) => RatingData(index + 1, 0, 0, 0, 0));
    coopRatingDataList.value = List<int>.generate(5, (index) => 0);

    for (var data in PlayDataService.to.clearDataList) {
      if (data.chartType == ChartType.SINGLE) {
        ratingDataList[data.level - 1].clearData.add(data);
        ratingDataList[data.level - 1].singleCount++;
        ratingDataList[data.level - 1].singleRating += data.rating();
      } else if (data.chartType == ChartType.DOUBLE) {
        ratingDataList[data.level - 1].clearData.add(data);
        ratingDataList[data.level - 1].doubleCount++;
        ratingDataList[data.level - 1].doubleRating += data.rating();
      } else if (data.chartType == ChartType.COOP) {
        coopRatingDataList[data.level - 1] += data.rating();
      }
    }
  }
}
