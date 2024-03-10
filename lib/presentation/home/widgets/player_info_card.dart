import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:piu_util/app/config/app_typeface.dart';
import 'package:piu_util/presentation/common/widgets/title_text.dart';

import '../controller/my_data_controller.dart';

class PlayerInfoCard extends GetView<MyDataController> {
  const PlayerInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(image: AssetImage("assets/image/bg1.png"), fit: BoxFit.cover),
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()));
        }

        return Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/avatar/${controller.myData.avatar}', width: 80),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(child: TitleText(controller.myData.titleText, controller.myData.titleType)),
                      FittedBox(child: Text(controller.myData.nickname, style: AppTypeFace.nickname)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
