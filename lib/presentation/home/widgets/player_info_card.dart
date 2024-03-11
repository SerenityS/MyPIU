import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:piu_util/app/config/app_typeface.dart';
import 'package:piu_util/app/config/extension/int_format_comma.dart';
import 'package:piu_util/presentation/common/widgets/title_text.dart';

import '../controller/my_data_controller.dart';

class PlayerInfoCard extends GetView<MyDataController> {
  const PlayerInfoCard({super.key, this.showCoin = false});

  final bool showCoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        image: const DecorationImage(image: AssetImage("assets/image/bg1.png"), fit: BoxFit.cover),
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: Padding(padding: EdgeInsets.all(8.w), child: const CircularProgressIndicator()));
        }

        return Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset('assets/avatar/${controller.myData.avatar}', width: 80.w),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(child: TitleText(controller.myData.titleText, controller.myData.titleType)),
                      FittedBox(child: Text(controller.myData.nickname, style: AppTypeFace().nickname)),
                    ],
                  ),
                ),
              ],
            ),
            if (showCoin) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset('assets/icon/coin.svg', width: 16.w, height: 16.w),
                  SizedBox(width: 4.w),
                  Text(
                    controller.myData.coin.formatWithComma(),
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, fontFamily: 'Oxanium'),
                  ),
                ],
              ),
            ],
          ],
        );
      }),
    );
  }
}
