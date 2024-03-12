import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:piu_util/domain/enum/chart_type.dart';

class StepBall extends StatelessWidget {
  const StepBall({super.key, required this.chartType, required this.level});

  final ChartType chartType;
  final int level;

  @override
  Widget build(BuildContext context) {
    String parsedLevel = level.toString().padLeft(2, "0");

    return SizedBox(
      height: 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (chartType == ChartType.UCS) ...[
            Image.asset("assets/step_ball/${ChartType.values[level].bgFileName}"),
          ] else ...[
            Image.asset("assets/step_ball/${chartType.bgFileName}"),
          ],
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/step_ball/${chartType.textFileName}"),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (chartType == ChartType.COOP) ...[
                        Image.asset("assets/step_ball/c_icon.png", width: 25),
                        Image.asset("assets/step_ball/${chartType.fileName}_num_${parsedLevel.toString()[1]}.png", width: 25),
                      ] else if (chartType == ChartType.UCS) ...[
                        Image.asset("assets/step_ball/u_num_x.png", width: 25),
                        Image.asset("assets/step_ball/u_num_x.png", width: 25),
                      ] else ...[
                        Image.asset("assets/step_ball/${chartType.fileName}_num_${parsedLevel.toString()[0]}.png", width: 25),
                        Image.asset("assets/step_ball/${chartType.fileName}_num_${parsedLevel.toString()[1]}.png", width: 25),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
