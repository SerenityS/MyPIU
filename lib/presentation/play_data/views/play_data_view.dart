import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:piu_util/domain/enum/chart_type.dart';

import '../controller/play_data_controller.dart';

class PlayDataView extends GetView<PlayDataController> {
  const PlayDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _LevelSelectHeader(),
            _BestScoreBody(),
          ],
        ),
      ),
    );
  }
}

class _LevelSelectHeader extends GetView<PlayDataController> {
  const _LevelSelectHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Single"),
        Obx(
          () => Switch(
              value: controller.currentChartType.value == ChartType.DOUBLE,
              onChanged: (value) {
                if (value) {
                  controller.currentChartType.value = ChartType.DOUBLE;
                } else {
                  controller.currentChartType.value = ChartType.SINGLE;
                }
              }),
        ),
        const Text("Double"),
        const Spacer(),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: controller.currentLevel.value.toString()),
            onChanged: (value) {
              if (value.isEmpty) {
                return;
              }
              controller.currentLevel.value = int.parse(value);
            },
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () async {
            await controller.getBestScoreData();
            await controller.generateClearData();
          },
          child: const Text("정보 갱신"),
        ),
      ],
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
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text("최신 정보로 업데이트 중 입니다."),
            ],
          );
        } else if (controller.clearDataList.isEmpty) {
          return const Text("정보가 없습니다.");
        }

        return GridView.builder(
          shrinkWrap: true,
          itemCount: controller.clearDataList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/jacket/${controller.clearDataList[index].jacketFileName}"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Text(
                    (controller.clearDataList[index].score / 10000).toStringAsFixed(1) == "0.0"
                        ? ""
                        : (controller.clearDataList[index].score / 10000).toStringAsFixed(1),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Colors.white),
                  ),
                  Text(
                    (controller.clearDataList[index].score / 10000).toStringAsFixed(1) == "0.0"
                        ? ""
                        : (controller.clearDataList[index].score / 10000).toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
