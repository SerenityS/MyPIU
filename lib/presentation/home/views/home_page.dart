import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/routes/route_path.dart';

import 'package:piu_util/presentation/home/controller/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        DateTime currentTime = DateTime.now();

        if (currentBackPressTime == null || currentTime.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
          currentBackPressTime = currentTime;
          Fluttertoast.showToast(msg: "한 번 더 누르시면 종료됩니다.", toastLength: Toast.LENGTH_SHORT);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Image.asset(
            height: 50.h,
            'assets/image/logo.png',
            fit: BoxFit.fitHeight,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => Get.toNamed(RoutePath.setting),
            ),
          ],
        ),
        body: Obx(() => SafeArea(child: controller.drawerPage)),
        drawer: Drawer(
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              ListTile(
                title: const Text('My Data'),
                onTap: () {
                  controller.drawerIndex = 0;
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Score Checker'),
                onTap: () {
                  controller.drawerIndex = 1;
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('My Best Score'),
                onTap: () {
                  controller.drawerIndex = 2;
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Rating Data'),
                onTap: () {
                  controller.drawerIndex = 3;
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Recently Play Data'),
                onTap: () {
                  controller.drawerIndex = 4;
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Title'),
                onTap: () {
                  controller.drawerIndex = 5;
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Avatar Shop'),
                onTap: () {
                  controller.drawerIndex = 6;
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
