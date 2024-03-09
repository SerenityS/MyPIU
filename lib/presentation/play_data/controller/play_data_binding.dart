import 'package:get/get.dart';

import 'play_data_controller.dart';

class PlayDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayDataController>(() => PlayDataController(), fenix: true);
  }
}
