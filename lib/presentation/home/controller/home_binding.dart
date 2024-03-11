import 'package:get/get.dart';
import 'package:piu_util/presentation/home/controller/home_controller.dart';
import 'package:piu_util/presentation/home/controller/setting_controller.dart';

import 'my_data_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.lazyPut<MyDataController>(() => MyDataController(), fenix: true);
    Get.lazyPut<SettingController>(() => SettingController(), fenix: true);
  }
}
