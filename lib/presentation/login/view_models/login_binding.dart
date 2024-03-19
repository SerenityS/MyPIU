import 'package:get/get.dart';

import 'login_view_model.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginViewModel>(() => LoginViewModel(), fenix: true);
  }
}
