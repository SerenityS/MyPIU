import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_typeface.dart';
import 'package:piu_util/app/config/extension/int_format_comma.dart';
import 'package:piu_util/presentation/common/widgets/step_ball.dart';
import 'package:piu_util/presentation/play_data/controller/best_score_controller.dart';

class BestScoreView extends GetView<BestScoreController> {
  const BestScoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.bestScoreDataList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1.5),
            borderRadius: BorderRadius.circular(8.r),
            image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
              image: AssetImage('assets/jacket/${controller.bestScoreDataList[index].jacketFileName}'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.bestScoreDataList[index].title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StepBall(chartType: controller.bestScoreDataList[index].chartType, level: controller.bestScoreDataList[index].level),
                  Column(
                    children: [
                      Image.asset('assets/grade/${controller.bestScoreDataList[index].gradeType.fileName}', height: 35.w),
                      Text(controller.bestScoreDataList[index].score.formatWithComma(),
                          style: AppTypeFace().judge.copyWith(fontSize: 14.sp)),
                    ],
                  ),
                  Image.asset('assets/plate/${controller.bestScoreDataList[index].plateType.fileName}', height: 40.w),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
