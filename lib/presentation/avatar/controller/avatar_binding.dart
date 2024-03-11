import 'package:get/get.dart';

import 'avatar_controller.dart';

class AvatarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AvatarController>(() => AvatarController(), fenix: true);
  }
}
