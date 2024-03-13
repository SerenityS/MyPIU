import 'package:get/get.dart';
import 'package:piu_util/presentation/play_data/controller/best_score_controller.dart';
import 'package:piu_util/presentation/play_data/controller/rating_controller.dart';
import 'package:piu_util/presentation/play_data/controller/recently_play_data_controller.dart';

import 'play_data_controller.dart';

class PlayDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BestScoreController>(() => BestScoreController(), fenix: true);
    Get.lazyPut<PlayDataController>(() => PlayDataController(), fenix: true);
    Get.lazyPut<RatingController>(() => RatingController(), fenix: true);
    Get.lazyPut<RecentlyPlayDataController>(() => RecentlyPlayDataController(), fenix: true);
  }
}
