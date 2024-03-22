import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/routes/route_path.dart';

import '../view_models/home_view_model.dart';

class HomePage extends GetView<HomeViewModel> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;

    Future<bool> onBackPress() async {
      DateTime currentTime = DateTime.now();

      if (currentBackPressTime == null || currentTime.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = currentTime;
        Fluttertoast.showToast(msg: "한 번 더 누르시면 종료됩니다.", toastLength: Toast.LENGTH_SHORT);
        return false;
      }
      return true;
    }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => onBackPress(),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Image.asset(height: 50.h, 'assets/image/logo.png', fit: BoxFit.fitHeight),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => Get.toNamed(RoutePath.setting),
            ),
          ],
        ),
        body: Obx(() => controller.drawerPage),
        drawer: Drawer(
          child: ListView.builder(
            itemCount: controller.drawerPages.length,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                title: Text(controller.drawerPages.keys.toList()[i]),
                onTap: () => controller.drawerIndex = i,
              );
            },
          ),
        ),
      ),
    );
  }
}
