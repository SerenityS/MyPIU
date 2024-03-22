import 'package:get/get.dart';
import 'package:piu_util/presentation/setting/view_models/setting_view_model.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingViewModel>(() => SettingViewModel(), fenix: true);
  }
}
