import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/app/service/play_data_service.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/enum/plate_type.dart';
import 'package:piu_util/presentation/common/widgets/piu_loading.dart';
import 'package:piu_util/presentation/play_data/widgets/player_info_card.dart';

import '../view_models/my_data_view_model.dart';

class HomeView extends GetView<MyDataViewModel> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const PIULoading("내 정보를 불러오는 중...");
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const PlayerInfoCard(),
                const _PlayerPlateCard(),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await controller.getClearDataFromRemote(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _PlayerPlateCard extends GetView<MyDataViewModel> {
  const _PlayerPlateCard();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: AppColor.cardSecondary),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: controller.isPlateLoading.value
              ? [
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: PIULoading(
                      "클리어 정보를 불러오는 중...(${PlayDataService.to.currentLoadingPageIndex}/${PlayDataService.to.totalPageIndex})",
                    ),
                  )
                ]
              : [
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Text(
                      "Plate Data",
                      style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold, fontFamily: 'Oxanium'),
                    ),
                  ),
                  Obx(() {
                    if (controller.isLoading.value) {
                      PIULoading("플레이트 정보를 불러오는 중...(${PlayDataService.to.currentLoadingPageIndex}/${PlayDataService.to.totalPageIndex})");
                    } else if (controller.clearDataList.isEmpty) {
                      return Center(
                        child: Text(
                          "플레이트 정보가 없습니다.\n게임을 플레이해주세요.",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                        ),
                      );
                    }

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      padding: EdgeInsets.zero,
                      itemCount: PlateType.values.length,
                      itemBuilder: (context, index) {
                        final PlateType plateType = PlateType.values[index];
                        final List<ChartData> clearDataList = controller.clearDataList.where((p0) => p0.plateType == plateType).toList();

                        return _PlateDetailCard(clearDataList, plateType);
                      },
                    );
                  }),
                ],
        ),
      );
    });
  }
}

class _PlateDetailCard extends GetView<MyDataViewModel> {
  const _PlateDetailCard(this.clearDataList, this.plateType);

  final List<ChartData> clearDataList;
  final PlateType plateType;

  @override
  Widget build(BuildContext context) {
    final singleMaxLevel = controller.getMaxLevelForType(clearDataList, plateType, ChartType.SINGLE).toString();
    final doubleMaxLevel = controller.getMaxLevelForType(clearDataList, plateType, ChartType.DOUBLE).toString();

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: AppColor.cardPrimary),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/plate/${plateType.fileName}'),
          SizedBox(height: 4.h),
          Text(
            clearDataList.length.toString(),
            style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold, fontFamily: 'Oxanium'),
          ),
          SizedBox(height: 4.h),
          buildChartTypeContainer(ChartType.SINGLE, singleMaxLevel),
          SizedBox(height: 4.h),
          buildChartTypeContainer(ChartType.DOUBLE, doubleMaxLevel),
        ],
      ),
    );
  }

  Widget buildChartTypeContainer(ChartType chartType, String count) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r), color: chartType == ChartType.SINGLE ? Colors.red : Colors.green),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(chartType.name, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'Oxanium')),
          Text(
            count,
            style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'Oxanium'),
          ),
        ],
      ),
    );
  }
}
