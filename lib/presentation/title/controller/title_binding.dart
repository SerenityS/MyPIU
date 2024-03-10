import 'package:get/get.dart';

import 'title_controller.dart';

class TitleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TitleController>(() => TitleController(), fenix: true);
  }
}
