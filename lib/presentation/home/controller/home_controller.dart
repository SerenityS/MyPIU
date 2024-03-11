import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:piu_util/presentation/avatar/views/avatar_view.dart';
import 'package:piu_util/presentation/home/views/my_data_view.dart';
import 'package:piu_util/presentation/play_data/views/play_data_view.dart';
import 'package:piu_util/presentation/play_data/views/recently_play_view.dart';
import 'package:piu_util/presentation/title/views/title_view.dart';

class HomeController extends GetxController {
  final List<Widget> drawerPages = [
    const MyDataView(),
    const PlayDataView(),
    const RecentlyPlayDataView(),
    const TitleView(),
    const AvatarView(),
  ];

  final _drawerIndex = 0.obs;
  set drawerIndex(int value) => _drawerIndex.value = value;

  get drawerPage => drawerPages[_drawerIndex.value];

  @override
  void onInit() async {
    super.onInit();

    // Initialize Hive
    Hive.init((await getApplicationDocumentsDirectory()).path);
    await Hive.openBox('avatar');
    await Hive.openBox('play_data');
    await Hive.openBox('title');
  }
}
