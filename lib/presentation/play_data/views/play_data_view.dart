import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await controller.takeScreenshot(),
        child: const Icon(Icons.photo_camera_outlined),
      ),
    );
  }
}

class _LevelSelectHeader extends GetView<PlayDataController> {
  const _LevelSelectHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.input,
      ),
      child: Row(
        children: [
          const Text("Single", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, fontFamily: 'Oxanium')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Obx(
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
          ),
          const Text("Double", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, fontFamily: 'Oxanium')),
          const Spacer(),
          SizedBox(
            width: 70,
            child: TextField(
              controller: TextEditingController(text: controller.currentLevel.value.toString()),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Oxanium'),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: AppColor.input,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColor.error)),
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColor.error)),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColor.error)),
                hintText: "레벨을 입력해주세요.",
                hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                prefix: const Text("Lv. ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontFamily: 'Oxanium')),
              ),
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text("PIU Phoenix ${controller.currentChartType.value.name} ${controller.currentLevel.value} Score List",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Oxanium')),
                            Text("Player: ${Get.find<MyDataController>().myData.nickname}",
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Oxanium')),
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
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 3
                                          ..color = Colors.white,
                                        fontFamily: 'Oxanium'),
                                  ),
                                  Text(
                                    (controller.clearDataList[i].score / 10000).toStringAsFixed(1) == "0.0"
                                        ? ""
                                        : (controller.clearDataList[i].score / 10000).toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Oxanium',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text("at ${DateTime.now().toString().substring(0, 16)}",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Oxanium')),
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
