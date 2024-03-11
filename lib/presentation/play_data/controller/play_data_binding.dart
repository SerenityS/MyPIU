import 'package:get/get.dart';
import 'package:piu_util/presentation/play_data/controller/recently_play_data_controller.dart';

import 'play_data_controller.dart';

class PlayDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayDataController>(() => PlayDataController(), fenix: true);
    Get.lazyPut<RecentlyPlayDataController>(() => RecentlyPlayDataController(), fenix: true);
  }
}
