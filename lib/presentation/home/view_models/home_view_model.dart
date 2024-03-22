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
  final List<Widget> drawerPages = [
    const HomeView(),
    const ScoreCheckerView(),
    const BestScoreView(),
    const RatingView(),
    const RecentlyPlayDataView(),
    const TitleView(),
    const AvatarView(),
  ];

  final _drawerIndex = 0.obs;
  int get drawerIndex => _drawerIndex.value;
  set drawerIndex(int value) => _drawerIndex.value = value;

  get drawerPage => drawerPages[_drawerIndex.value];

  @override
  void onInit() async {
    super.onInit();

    _drawerIndex.value = int.parse(Get.parameters['index']!);
  }
}
