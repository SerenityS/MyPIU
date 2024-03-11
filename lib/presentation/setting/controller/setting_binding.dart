import 'package:get/get.dart';
import 'package:piu_util/presentation/setting/controller/setting_controller.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(() => SettingController(), fenix: true);
  }
}
