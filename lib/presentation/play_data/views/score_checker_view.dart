import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/app/config/app_typeface.dart';
import 'package:piu_util/app/config/extension/score_to_string.dart';
import 'package:piu_util/app/service/play_data_service.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/presentation/common/widgets/piu_card.dart';
import 'package:piu_util/presentation/common/widgets/piu_loading.dart';
import 'package:piu_util/presentation/play_data/view_models/my_data_view_model.dart';

import '../view_models/score_checker_view_model.dart';

class ScoreCheckerView extends GetView<ScoreCheckerViewModel> {
  const ScoreCheckerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Column(
          children: [
            _FilterHeader(),
            _BestScoreBody(),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () async {
            if (controller.isLoading || controller.isCapture.value) return;

            await controller.takeScreenshot();
          },
          child: controller.isCapture.value
              ? Padding(
                  padding: EdgeInsets.all(12.w),
                  child: const CircularProgressIndicator(),
                )
              : const Icon(Icons.photo_camera_outlined),
        ),
      ),
    );
  }
}

class _FilterHeader extends GetView<ScoreCheckerViewModel> {
  const _FilterHeader();

  @override
  Widget build(BuildContext context) {
    return PIUCard(
      padding: EdgeInsets.all(8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Obx(() => Checkbox(value: controller.showSingle.value, onChanged: (value) => controller.showSingle.value = value!)),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => controller.showSingle.value = !controller.showSingle.value,
                  child: Text("Single", style: TextStyle(fontSize: 15.sp, fontFamily: 'Oxanium'))),
            ],
          ),
          Row(
            children: [
              Obx(() => Checkbox(value: controller.showDouble.value, onChanged: (value) => controller.showDouble.value = value!)),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => controller.showDouble.value = !controller.showDouble.value,
                  child: Text("Double", style: TextStyle(fontSize: 15.sp, fontFamily: 'Oxanium'))),
            ],
          ),
          SizedBox(
            width: 70.w,
            child: Obx(
              () => TextField(
                enabled: !controller.isLoading,
                controller: controller.lvTextController,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, fontFamily: 'Oxanium'),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
                  filled: true,
                  fillColor: AppColor.input,
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: const BorderSide(color: Colors.lightBlue)),
                  enabledBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: const BorderSide(color: Colors.lightBlue)),
                  focusedBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: const BorderSide(color: Colors.lightBlue)),
                  hintText: "0",
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  prefix: Text("Lv. ", style: TextStyle(fontSize: 14.sp, fontFamily: 'Oxanium')),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  if (value.isEmpty) return;

                  controller.currentLevel.value = int.parse(value);
                },
                onTapOutside: (PointerDownEvent event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BestScoreBody extends GetView<ScoreCheckerViewModel> {
  const _BestScoreBody();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading) {
          return PIULoading("최신 정보로 업데이트 중 입니다...(${PlayDataService.to.currentLoadingPageIndex}/${PlayDataService.to.totalPageIndex})");
        } else if (controller.singleClearDataList.isEmpty && controller.doubleClearDataList.isEmpty) {
          return Center(child: Text("해당 레벨에 대한 정보가 없습니다.", style: AppTypeFace().loading));
        }

        return const _ScoreView();
      }),
    );
  }
}

class _ScoreView extends GetView<ScoreCheckerViewModel> {
  const _ScoreView();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            RepaintBoundary(
              key: controller.scoreWidgetKey,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Container(
                  color: AppColor.bg,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          children: [
                            Text("PIU Phoenix Lv.${controller.currentLevel.value} Score List",
                                style: TextStyle(fontSize: 20.sp, fontFamily: 'Oxanium')),
                            Text("Player: ${Get.find<MyDataViewModel>().myData.nickname}",
                                style: TextStyle(fontSize: 20.sp, fontFamily: 'Oxanium')),
                          ],
                        ),
                      ),
                      if (controller.showSingle.value) ...[
                        _ScoreGridWidget("Single", clearDataList: controller.singleClearDataList, color: Colors.red),
                      ],
                      if (controller.showDouble.value) ...[
                        _ScoreGridWidget("Double", clearDataList: controller.doubleClearDataList, color: Colors.green),
                      ],
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 0.w, 8.w, 8.w),
                        child: Column(
                          children: [
                            Text("at ${DateTime.now().toString().substring(0, 16)}",
                                style: TextStyle(fontSize: 14.sp, fontFamily: 'Oxanium')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreGridWidget extends StatelessWidget {
  const _ScoreGridWidget(this.title, {required this.clearDataList, required this.color});

  final List<ChartData> clearDataList;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 20.sp, fontFamily: 'Oxanium', color: color)),
        Wrap(
          children: [
            for (int i = 0; i < clearDataList.length; i++)
              Container(
                width: Get.width / 5,
                height: Get.width / 7,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/jacket/${clearDataList[i].jacketFileName}"),
                    fit: BoxFit.cover,
                    colorFilter: (clearDataList[i].score.toScoreString()) == "0.0"
                        ? ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken)
                        : null,
                  ),
                ),
                child: Stack(
                  children: [
                    Text(
                      (clearDataList[i].score.toScoreString()) == "0.0" ? "" : clearDataList[i].score.toScoreString(),
                      style: TextStyle(
                          fontSize: 30.sp,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3.5.w
                            ..color = Colors.white,
                          fontFamily: 'Oxanium'),
                    ),
                    Text(
                      (clearDataList[i].score.toScoreString()) == "0.0" ? "" : clearDataList[i].score.toScoreString(),
                      style: TextStyle(
                        fontSize: 30.sp,
                        color: clearDataList[i].score >= 950000
                            ? const Color(0xFF005AFF)
                            : clearDataList[i].score >= 900000
                                ? const Color(0xFF32CD32)
                                : clearDataList[i].score >= 850000
                                    ? const Color(0xFFFFD700)
                                    : Colors.red,
                        fontFamily: 'Oxanium',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
