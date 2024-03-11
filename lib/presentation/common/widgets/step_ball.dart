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
    return FittedBox(
      child: SizedBox(
        height: 50,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset("assets/step_ball/${chartType.bgFileName}"),
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
                        Image.asset("assets/step_ball/${chartType.fileName}_num_${level.toString()[0]}.png", width: 25),
                        Image.asset("assets/step_ball/${chartType.fileName}_num_${level.toString()[1]}.png", width: 25),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
