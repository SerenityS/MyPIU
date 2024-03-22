import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piu_util/presentation/avatar/views/avatar_view.dart';
import 'package:piu_util/presentation/play_data/views/my_data_view.dart';
import 'package:piu_util/presentation/play_data/views/best_score_view.dart';
import 'package:piu_util/presentation/play_data/views/score_checker_view.dart';
import 'package:piu_util/presentation/play_data/views/rating_view.dart';
import 'package:piu_util/presentation/play_data/views/recently_play_view.dart';
import 'package:piu_util/presentation/title/views/title_view.dart';

class HomeViewModel extends GetxController {
  final Map<String, Widget> drawerPages = {
    "My Data": const HomeView(),
    "Score Checker": const ScoreCheckerView(),
    "My Best Score": const BestScoreView(),
    "Rating Data": const RatingView(),
    "Recently Play Data": const RecentlyPlayDataView(),
    "Title": const TitleView(),
    "Avatar Shop": const AvatarView(),
  };

  final _drawerIndex = 0.obs;
  int get drawerIndex => _drawerIndex.value;
  set drawerIndex(int value) {
    _drawerIndex.value = value;
    Get.back();
  }

  get drawerPage => drawerPages[drawerPages.keys.toList()[drawerIndex]];

  @override
  void onInit() async {
    super.onInit();

    _drawerIndex.value = int.parse(Get.parameters['index']!);
  }
}
