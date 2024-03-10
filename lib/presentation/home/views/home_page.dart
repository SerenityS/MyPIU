import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:piu_util/app/config/app_color.dart';

import 'package:piu_util/presentation/home/controller/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Image.asset(
          height: 50,
          'assets/image/logo.png',
          fit: BoxFit.fitHeight,
        ),
        centerTitle: true,
      ),
      body: Obx(() => SafeArea(child: controller.drawerPage)),
      drawer: Drawer(
        backgroundColor: AppColor.cardPrimary,
        child: ListView(
          children: [
            ListTile(
              title: const Text('My Profile'),
              onTap: () {
                controller.drawerIndex = 0;
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Title'),
              onTap: () {
                controller.drawerIndex = 1;
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
