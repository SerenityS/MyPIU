import 'package:get/get.dart';

import 'home_view_model.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeViewModel());
  }
}
