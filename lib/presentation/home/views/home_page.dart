import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        child: ListView(
          physics: const ClampingScrollPhysics(),
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
            ListTile(
              title: const Text('Score Checker'),
              onTap: () {
                controller.drawerIndex = 2;
                Get.back();
              },
            ),
            ListTile(
              title: const Text('Avatar Shop'),
              onTap: () {
                controller.drawerIndex = 3;
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
