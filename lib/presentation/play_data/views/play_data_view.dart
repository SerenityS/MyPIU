import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/app/config/app_typeface.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/presentation/home/controller/my_data_controller.dart';

import '../controller/play_data_controller.dart';

class PlayDataView extends GetView<PlayDataController> {
  const PlayDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Column(
          children: [
            _LevelSelectHeader(),
            _BestScoreBody(),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () async {
            if (controller.isLoading.value || controller.isCapture.value) return;

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

class _LevelSelectHeader extends GetView<PlayDataController> {
  const _LevelSelectHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColor.input,
      ),
      child: Row(
        children: [
          Text("Single", style: TextStyle(fontSize: 15.sp, fontFamily: 'Oxanium')),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Obx(
              () => Switch(
                  value: controller.currentChartType.value == ChartType.DOUBLE,
                  onChanged: (value) {
                    if (controller.isLoading.value) return;

                    if (value) {
                      controller.currentChartType.value = ChartType.DOUBLE;
                    } else {
                      controller.currentChartType.value = ChartType.SINGLE;
                    }
                  }),
            ),
          ),
          Text("Double", style: TextStyle(fontSize: 15.sp, fontFamily: 'Oxanium')),
          const Spacer(),
          SizedBox(
            width: 70.w,
            child: Obx(
              () => TextField(
                enabled: !controller.isLoading.value,
                controller: controller.lvTextController,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, fontFamily: 'Oxanium'),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
                  filled: true,
                  fillColor: AppColor.input,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: const BorderSide(color: AppColor.error)),
                  enabledBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: const BorderSide(color: AppColor.error)),
                  focusedBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: const BorderSide(color: AppColor.error)),
                  hintText: "레벨을 입력해주세요.",
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  prefix: Text("Lv. ", style: TextStyle(fontSize: 14.sp, fontFamily: 'Oxanium')),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  if (value.isEmpty) {
                    return;
                  }

                  controller.currentLevel.value = int.parse(value);
                },
                onTapOutside: (PointerDownEvent event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.value) return;

              await controller.getBestScoreData();
              await controller.generateClearData();
            },
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class _BestScoreBody extends GetView<PlayDataController> {
  const _BestScoreBody();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 8.h),
              Text("최신 정보로 업데이트 중 입니다...(${controller.currentLoadingPageIndex}/${controller.totalPageIndex})",
                  style: AppTypeFace().loading),
            ],
          );
        } else if (controller.clearDataList.isEmpty) {
          return Center(child: Text("해당 레벨에 대한 정보가 없습니다.", style: AppTypeFace().loading));
        }

        return const _BestScoreGridView();
      }),
    );
  }
}

class _BestScoreGridView extends GetView<PlayDataController> {
  const _BestScoreGridView();

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
                            Text("PIU Phoenix ${controller.currentChartType.value.name} ${controller.currentLevel.value} Score List",
                                style: TextStyle(fontSize: 20.sp, fontFamily: 'Oxanium')),
                            Text("Player: ${Get.find<MyDataController>().myData.nickname}",
                                style: TextStyle(fontSize: 20.sp, fontFamily: 'Oxanium')),
                          ],
                        ),
                      ),
                      Wrap(
                        children: [
                          for (int i = 0; i < controller.clearDataList.length; i++)
                            Container(
                              width: Get.width / 5,
                              height: Get.width / 7,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/jacket/${controller.clearDataList[i].jacketFileName}"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Text(
                                    (controller.clearDataList[i].score / 10000).toStringAsFixed(1) == "0.0"
                                        ? ""
                                        : (controller.clearDataList[i].score / 10000).toStringAsFixed(1),
                                    style: TextStyle(
                                        fontSize: 30.sp,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 3.5.w
                                          ..color = Colors.white,
                                        fontFamily: 'Oxanium'),
                                  ),
                                  Text(
                                    (controller.clearDataList[i].score / 10000).toStringAsFixed(1) == "0.0"
                                        ? ""
                                        : (controller.clearDataList[i].score / 10000).toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 30.sp,
                                      color: controller.clearDataList[i].score >= 950000
                                          ? const Color(0xFF005AFF)
                                          : controller.clearDataList[i].score >= 900000
                                              ? const Color(0xFF32CD32)
                                              : controller.clearDataList[i].score >= 850000
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
                      Padding(
                        padding: EdgeInsets.all(8.w),
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
