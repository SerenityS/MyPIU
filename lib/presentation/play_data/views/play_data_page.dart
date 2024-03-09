import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:piu_util/domain/enum/chart_type.dart';

import '../controller/play_data_controller.dart';

class PlayDataPage extends GetView<PlayDataController> {
  const PlayDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
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
                  ElevatedButton(
                    onPressed: () async {
                      await controller.getClearData();
                    },
                    child: const Text("Update Data"),
                  ),
                ],
              ),
              Obx(() {
                if (controller.clearDataList.isEmpty) {
                  return const CircularProgressIndicator();
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
              })
            ],
          ),
        ),
      ),
    );
  }
}
