import 'package:get/get.dart';
import 'package:piu_util/domain/entities/chart_data.dart';

import 'play_data_controller.dart';

class BestScoreController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    bestScoreDataList = Get.find<PlayDataController>().bestScoreDataList;

    ever(Get.find<PlayDataController>().bestScoreDataList, (_) {
      bestScoreDataList = Get.find<PlayDataController>().bestScoreDataList;
    });
  }

  List<ChartData> bestScoreDataList = <ChartData>[].obs;
  List<ChartData> filterBestScoreDataList = <ChartData>[].obs;
}
