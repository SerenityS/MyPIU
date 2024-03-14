import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/routes/route_path.dart';
import 'package:piu_util/domain/enum/term_type.dart';

import '../controller/setting_controller.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: Column(
        children: [
          ListTile(title: const Text('서비스 이용 약관'), onTap: () => Get.toNamed(RoutePath.term, arguments: TermType.termOfUse)),
          ListTile(title: const Text('개인정보 처리방침'), onTap: () => Get.toNamed(RoutePath.term, arguments: TermType.privacyPolicy)),
          ListTile(
            title: const Text('로그아웃'),
            onTap: () async => await controller.logout(),
          ),
          ListTile(title: const Text('Open Source Licences'), onTap: () => Get.toNamed(RoutePath.licences)),
          ListTile(title: Obx(() => Text('App Version : ${controller.appVersion}'))),
          ListTile(title: Text('PIU Asset Version : ${controller.assetVersion}')),
          const ListTile(title: Text('Made by qwertycvb')),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("This app is non-commercial usage only.", style: TextStyle(color: Colors.red)),
                Text(
                    "This app is not affiliated with PUMPITUP & Andamiro Co., LTD.\nAll trademarks and copyrights are the property of their respective owners."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
