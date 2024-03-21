import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:piu_util/app/service/play_data_service.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';

class ScoreCheckerViewModel extends GetxController {
  // Service
  final PlayDataService _playDataService = Get.find<PlayDataService>();

  // Loading State
  bool get isLoading => _playDataService.totalPageIndex.value != 0;
  final RxBool isCapture = false.obs;

  // Filter
  final RxBool showSingle = true.obs;
  final RxBool showDouble = true.obs;
  final RxInt currentLevel = 0.obs;
  final TextEditingController lvTextController = TextEditingController();

  // Data
  List<ChartData> get clearDataList => PlayDataService.to.clearDataList;
  final RxList<ChartData> singleClearDataList = <ChartData>[].obs;
  final RxList<ChartData> doubleClearDataList = <ChartData>[].obs;

  // View
  final GlobalKey scoreWidgetKey = GlobalKey();

  @override
  void onInit() async {
    super.onInit();

    // Set currentLevel to the highest level
    for (var element in clearDataList) {
      if (currentLevel.value < element.level) {
        currentLevel.value = element.level;
      }
    }
    lvTextController.text = currentLevel.value.toString();

    // Generate score checker data
    await _generateScoreData();

    // Generate score checker data when the filter changes
    _listenChanges();
  }

  void _listenChanges() {
    ever(currentLevel, (_) => _generateScoreData());
    ever(showSingle, (_) => _generateScoreData());
    ever(showDouble, (_) => _generateScoreData());
  }

  Future<void> _generateScoreData() async {
    await _playDataService.setLevelData(currentLevel.value);

    if (showSingle.value) singleClearDataList.assignAll(await _playDataService.generateDataList(ChartType.SINGLE));
    if (showDouble.value) doubleClearDataList.assignAll(await _playDataService.generateDataList(ChartType.DOUBLE));
  }

  Future<void> takeScreenshot() async {
    isCapture(true);
    try {
      RenderRepaintBoundary boundary = scoreWidgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final result = await ImageGallerySaver.saveImage(pngBytes, name: "score_${DateTime.now().toIso8601String()}");
      Fluttertoast.showToast(msg: result['isSuccess'] ? "이미지를 저장했습니다." : "이미지를 저장하지 못했습니다.");
    } finally {
      isCapture(false);
    }
  }
}
