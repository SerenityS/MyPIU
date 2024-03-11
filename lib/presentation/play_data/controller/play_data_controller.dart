import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:piu_util/data/datasources/local/play_data_local_data_source.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/entities/play_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/usecases/play_data_usecases.dart';

class PlayDataController extends GetxController {
  final PlayDataUseCases _useCases = Get.find<PlayDataUseCases>();
  final PlayDataLocalDataSource _playDataSource = PlayDataLocalDataSource();

  final RxBool isLoading = true.obs;

  final Rx<ChartType> currentChartType = ChartType.DOUBLE.obs;
  final RxInt currentLevel = 24.obs;

  final RxList<ChartData> clearDataList = <ChartData>[].obs;
  final RxList<ChartData> bestScoreDataList = <ChartData>[].obs;
  final RxList<ChartData> levelDataList = <ChartData>[].obs;

  final RxList<PlayData> playDataList = <PlayData>[].obs;

  final GlobalKey scoreWidgetKey = GlobalKey();

  @override
  void onInit() async {
    super.onInit();

    final List<ChartData>? clearData = _playDataSource.getClearData();
    if (clearData == null) {
      await getBestScoreData();
    } else {
      bestScoreDataList.assignAll(clearData);
    }

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
    try {
      var jsonString = await rootBundle.loadString('assets/json/${currentChartType.value.name}_$currentLevel.json');
      levelDataList.assignAll((json.decode(jsonString) as List).map((e) => ChartData.fromJson(e)).toList());
    } catch (e) {
      levelDataList.assignAll([]);
    }
  }

  Future<void> getBestScoreData() async {
    isLoading.value = true;
    // Get Best Score Data from web
    bestScoreDataList.assignAll(await _useCases.getBestScore.execute());
    await _playDataSource.saveClearData(bestScoreDataList);
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

    isLoading.value = false;
  }

  Future<void> getPlayData() async {
    playDataList.assignAll(await _useCases.getPlayData.execute(currentLevel.value));
  }

  Future<void> takeScreenshot() async {
    RenderRepaintBoundary boundary = scoreWidgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    var result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(pngBytes),
      name:
          "score_check_${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}",
    );

    if (result['isSuccess']) {
      Fluttertoast.showToast(msg: "이미지를 갤러리에 저장했습니다.");
    } else {
      Fluttertoast.showToast(msg: "이미지를 저장하지 못했습니다.");
    }
  }
}
