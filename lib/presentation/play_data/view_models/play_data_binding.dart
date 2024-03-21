import 'package:get/get.dart';

import 'best_score_view_model.dart';
import 'my_data_view_model.dart';
import 'rating_view_model.dart';
import 'recently_play_data_view_model.dart';
import 'score_checker_view_model.dart';

class PlayDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BestScoreViewModel>(() => BestScoreViewModel(), fenix: true);
    Get.lazyPut<MyDataViewModel>(() => MyDataViewModel(), fenix: true);
    Get.lazyPut<RatingViewModel>(() => RatingViewModel(), fenix: true);
    Get.lazyPut<RecentlyPlayDataViewModel>(() => RecentlyPlayDataViewModel(), fenix: true);
    Get.lazyPut<ScoreCheckerViewModel>(() => ScoreCheckerViewModel(), fenix: true);
  }
}
