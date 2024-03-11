import 'package:flutter/material.dart';
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
        ],
      ),
    );
  }
}
