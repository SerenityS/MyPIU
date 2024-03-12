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
  final TextEditingController lvTextController = TextEditingController();

  final RxBool isLoading = true.obs;
  final RxBool isCapture = false.obs;

  final RxBool showSingle = true.obs;
  final RxBool showDouble = true.obs;

  final RxInt currentLevel = 0.obs;

  final RxInt totalPageIndex = 0.obs;
  final RxInt currentLoadingPageIndex = 0.obs;

  final RxList<ChartData> singleClearDataList = <ChartData>[].obs;
  final RxList<ChartData> doubleClearDataList = <ChartData>[].obs;

  final RxList<ChartData> clearDataList = <ChartData>[].obs;
  final RxList<ChartData> bestScoreDataList = <ChartData>[].obs;

  final RxList<ChartData> singleLevelDataList = <ChartData>[].obs;
  final RxList<ChartData> doubleLevelDataList = <ChartData>[].obs;

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

    for (var element in bestScoreDataList) {
      if (currentLevel.value < element.level) {
        currentLevel.value = element.level;
      }
    }
    lvTextController.text = currentLevel.value.toString();

    await generateClearData();

    ever(currentLevel, (_) async {
      await generateClearData();
    });

    ever(showSingle, (_) async {
      await generateClearData();
    });

    ever(showDouble, (_) async {
      await generateClearData();
    });
  }

  Future<void> getSingleLevelData() async {
    // Get Chart Data from JSON
    try {
      var singleJsonString = await rootBundle.loadString('assets/json/SINGLE_$currentLevel.json');

      singleLevelDataList.assignAll((json.decode(singleJsonString) as List).map((e) => ChartData.fromJson(e)).toList());
    } catch (e) {
      singleLevelDataList.assignAll([]);
    }
  }

  Future<void> getDoubleLevelData() async {
    // Get Chart Data from JSON
    try {
      var doubleJsonString = await rootBundle.loadString('assets/json/DOUBLE_$currentLevel.json');

      doubleLevelDataList.assignAll((json.decode(doubleJsonString) as List).map((e) => ChartData.fromJson(e)).toList());
    } catch (e) {
      doubleLevelDataList.assignAll([]);
    }
  }

  Future<void> getBestScoreData() async {
    try {
      isLoading.value = true;
      // Get Best Score Data from web
      bestScoreDataList.assignAll(await _useCases.getBestScore.execute());
      await _playDataSource.saveClearData(bestScoreDataList);
    } catch (e) {
      bestScoreDataList.assignAll([]);
    }
  }

  Future<void> generateClearData() async {
    await getSingleLevelData();
    await getDoubleLevelData();

    // Generate Clear Data
    List<ChartData> singleGeneratedData = [];
    List<ChartData> doubleGeneratedData = [];

    for (var chartData in singleLevelDataList) {
      var matchingData = bestScoreDataList.firstWhereOrNull(
        (clearData) => clearData.title == chartData.title && clearData.level == chartData.level && clearData.chartType == ChartType.SINGLE,
      );

      if (matchingData != null) {
        singleGeneratedData.add(
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
        singleGeneratedData.add(chartData);
      }
    }

    for (var chartData in doubleLevelDataList) {
      var matchingData = bestScoreDataList.firstWhereOrNull(
        (clearData) => clearData.title == chartData.title && clearData.level == chartData.level && clearData.chartType == ChartType.DOUBLE,
      );

      if (matchingData != null) {
        doubleGeneratedData.add(
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
        doubleGeneratedData.add(chartData);
      }
    }

    singleGeneratedData.sort((a, b) => b.score.compareTo(a.score));
    doubleGeneratedData.sort((a, b) => b.score.compareTo(a.score));

    singleClearDataList.assignAll(singleGeneratedData);
    doubleClearDataList.assignAll(doubleGeneratedData);

    isLoading.value = false;
  }

  Future<void> getPlayData() async {
    playDataList.assignAll(await _useCases.getPlayData.execute(currentLevel.value));
  }

  Future<void> takeScreenshot() async {
    isCapture.value = true;

    try {
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
        Fluttertoast.showToast(msg: "이미지를 저장했습니다.");
      } else {
        Fluttertoast.showToast(msg: "이미지를 저장하지 못했습니다.");
      }
    } finally {
      isCapture.value = false;
    }
  }
}
