import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/enum/plate_type.dart';
import 'package:piu_util/presentation/play_data/controller/play_data_controller.dart';

import '../widgets/player_info_card.dart';

class MyDataView extends StatelessWidget {
  const MyDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          PlayerInfoCard(),
          _PlayerPlateCard(),
        ],
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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColor.cardSecondary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(4),
            child:
                Text("Plate Data", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Oxanium')),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.bestScoreDataList.isEmpty) {
              return const Center(child: Text("No Data"));
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
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColor.cardPrimary),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/plate/${PlateType.values[index].fileName}'),
          const SizedBox(height: 4),
          Text(
            clearDataList.length.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Oxanium'),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Colors.red),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("SINGLE", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                Text(
                  clearDataList
                      .where((element) => element.plateType == PlateType.values[index] && element.chartType == ChartType.SINGLE)
                      .fold<int>(0, (highest, element) => highest > element.level ? highest : element.level)
                      .toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Oxanium'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Colors.green),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("DOUBLE", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                Text(
                  clearDataList
                      .where((element) => element.plateType == PlateType.values[index] && element.chartType == ChartType.DOUBLE)
                      .fold<int>(0, (highest, element) => highest > element.level ? highest : element.level)
                      .toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Oxanium'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
