import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/app/config/app_typeface.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/enum/plate_type.dart';
import 'package:piu_util/presentation/play_data/controller/play_data_controller.dart';

import '../controller/my_data_controller.dart';
import '../widgets/player_info_card.dart';

class MyDataView extends GetView<MyDataController> {
  const MyDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(child: CircularProgressIndicator()),
              SizedBox(height: 8.h),
              Text("내 정보를 불러오는 중...", style: AppTypeFace().loading),
            ],
          );
        }

        return const SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              PlayerInfoCard(),
              _PlayerPlateCard(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final controller = Get.find<PlayDataController>();

          if (controller.isLoading.value) return;

          await controller.getBestScoreData();
          await controller.generateClearData();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _PlayerPlateCard extends GetView<PlayDataController> {
  const _PlayerPlateCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: AppColor.cardSecondary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text("Plate Data",
                style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold, fontFamily: 'Oxanium')),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 4.w),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(height: 8.h),
                      Text("플레이트 정보를 불러오는 중...(${controller.currentLoadingPageIndex}/${controller.totalPageIndex})",
                          style: AppTypeFace().loading),
                    ],
                  ),
                ),
              );
            } else if (controller.bestScoreDataList.isEmpty) {
              return Center(
                  child: Text(
                "플레이트 정보가 없습니다.\n게임을 플레이해주세요.",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ));
            }

            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              padding: EdgeInsets.zero,
              itemCount: PlateType.values.length,
              itemBuilder: (context, index) {
                return _PlateDetailCard(index);
              },
            );
          }),
        ],
      ),
    );
  }
}

class _PlateDetailCard extends GetView<PlayDataController> {
  const _PlateDetailCard(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    final List<ChartData> clearDataList = controller.bestScoreDataList.where((p0) => p0.plateType == PlateType.values[index]).toList();

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: AppColor.cardPrimary),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/plate/${PlateType.values[index].fileName}'),
          SizedBox(height: 4.h),
          Text(
            clearDataList.length.toString(),
            style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold, fontFamily: 'Oxanium'),
          ),
          SizedBox(height: 4.h),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: Colors.red),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("SINGLE", style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'Oxanium')),
                Text(
                  clearDataList
                      .where((element) => element.plateType == PlateType.values[index] && element.chartType == ChartType.SINGLE)
                      .fold<int>(0, (highest, element) => highest > element.level ? highest : element.level)
                      .toString(),
                  style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'Oxanium'),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: Colors.green),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("DOUBLE", style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'Oxanium')),
                Text(
                  clearDataList
                      .where((element) => element.plateType == PlateType.values[index] && element.chartType == ChartType.DOUBLE)
                      .fold<int>(0, (highest, element) => highest > element.level ? highest : element.level)
                      .toString(),
                  style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'Oxanium'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
