import 'package:get/get.dart';

import 'title_view_model.dart';

class TitleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TitleViewModel>(() => TitleViewModel(), fenix: true);
  }
}
