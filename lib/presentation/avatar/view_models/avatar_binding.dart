import 'package:get/get.dart';

import 'avatar_view_model.dart';

class AvatarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AvatarViewModel>(() => AvatarViewModel(), fenix: true);
  }
}
