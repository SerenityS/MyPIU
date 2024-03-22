import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/app/config/app_typeface.dart';
import 'package:piu_util/app/config/extension/int_format_comma.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/enum/grade_type.dart';
import 'package:piu_util/domain/enum/plate_type.dart';
import 'package:piu_util/presentation/common/widgets/piu_image_card.dart';
import 'package:piu_util/presentation/common/widgets/piu_text_field.dart';
import 'package:piu_util/presentation/common/widgets/step_ball.dart';
import 'package:piu_util/presentation/play_data/view_models/best_score_view_model.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

void _debounceFilterChange(VoidCallback onDebounce) {
  final Debouncer debouncer = Debouncer();

  debouncer.debounce(
    duration: const Duration(milliseconds: 100),
    onDebounce: onDebounce,
  );
}

class BestScoreView extends GetView<BestScoreViewModel> {
  const BestScoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      body: Scrollbar(
        controller: scrollController,
        child: Obx(
          () => ListView.builder(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            itemCount: controller.filterBestScoreDataList.length,
            itemBuilder: (BuildContext context, int index) {
              return PIUImageCard(
                jacketFileName: controller.filterBestScoreDataList[index].jacketFileName,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.filterBestScoreDataList[index].title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StepBall(
                            chartType: controller.filterBestScoreDataList[index].chartType,
                            level: controller.filterBestScoreDataList[index].level),
                        Column(
                          children: [
                            Image.asset('assets/grade/${controller.filterBestScoreDataList[index].gradeType.fileName}', height: 35.w),
                            Text(controller.filterBestScoreDataList[index].score.formatWithComma(),
                                style: AppTypeFace().judge.copyWith(fontSize: 14.sp)),
                          ],
                        ),
                        Image.asset('assets/plate/${controller.filterBestScoreDataList[index].plateType.fileName}', height: 40.w),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _showFilterModal(context),
        child: const Icon(Icons.filter_list_outlined),
      ),
    );
  }
}

Future<void> _showFilterModal(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: AppColor.bg,
    barrierColor: Colors.black.withOpacity(0.4),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
    ),
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(12.w, 20.w, 12.w, 12.w),
          width: double.maxFinite,
          child: GetX<BestScoreViewModel>(
            builder: (controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Title", style: AppTypeFace().filterTitle),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.w),
                    child: PIUTextField(
                        isEnable: true,
                        controller: controller.searchController,
                        onChanged: (value) => _debounceFilterChange(() => controller.filterBestScoreData()),
                        hintText: "곡 제목을 입력해주세요."),
                  ),
                  SizedBox(height: 12.w),
                  Text("Type", style: AppTypeFace().filterTitle),
                  Row(
                    children: [
                      _RankChip(
                        ChartType.SINGLE.name,
                        onTap: () => _debounceFilterChange(() => controller.toggleChartType(ChartType.SINGLE)),
                        isEnable: controller.chartTypeList.contains(ChartType.SINGLE),
                      ),
                      _RankChip(
                        ChartType.DOUBLE.name,
                        onTap: () => _debounceFilterChange(() => controller.toggleChartType(ChartType.DOUBLE)),
                        isEnable: controller.chartTypeList.contains(ChartType.DOUBLE),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.w),
                  Text("Grade", style: AppTypeFace().filterTitle),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                      children: [
                        for (int i = 16; i < 27; i++) ...[
                          _RankChip(
                            GradeType.values[i].name,
                            onTap: () => _debounceFilterChange(() => controller.toggleGradeType(GradeType.values[i])),
                            isEnable: controller.gradeTypeList.contains(GradeType.values[i]),
                          ),
                        ],
                        _RankChip(
                          "A 이하",
                          onTap: () => _debounceFilterChange(() => controller.toggleGradeType(GradeType.A)),
                          isEnable: controller.gradeTypeList.contains(GradeType.A),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.w),
                  Text("Plate", style: AppTypeFace().filterTitle),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < PlateType.values.length; i++) ...[
                          _RankChip(
                            PlateType.values[i].name,
                            onTap: () => _debounceFilterChange(() => controller.togglePlateType(PlateType.values[i])),
                            isEnable: controller.plateTypeList.contains(PlateType.values[i]),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 12.w),
                  Text("Level", style: AppTypeFace().filterTitle),
                  const _LevelSlider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller.minLevel.value.toStringAsFixed(0), style: TextStyle(fontSize: 14.sp, fontFamily: 'Oxanium')),
                        Text(controller.maxLevel.value.toStringAsFixed(0), style: TextStyle(fontSize: 14.sp, fontFamily: 'Oxanium')),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

class _RankChip extends StatelessWidget {
  const _RankChip(this.text, {required this.onTap, required this.isEnable});

  final String text;
  final VoidCallback onTap;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.w),
        decoration: BoxDecoration(
          color: AppColor.cardPrimary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          text.replaceAll("p", "+"),
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, fontFamily: 'Oxanium', color: isEnable ? Colors.red : Colors.grey),
        ),
      ),
    );
  }
}

class _LevelSlider extends GetView<BestScoreViewModel> {
  const _LevelSlider();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SfRangeSlider(
        values: controller.rangeValues.value,
        min: controller.minLevel.value.toDouble(),
        max: controller.maxLevel.value.toDouble(),
        showTicks: true,
        showDividers: true,
        interval: 1.0,
        stepSize: 1.0,
        enableTooltip: true,
        startThumbIcon: Center(
          child: Text(
            controller.rangeValues.value.start.round().toString(),
            style: TextStyle(fontSize: 11.sp, fontFamily: 'Oxanium'),
          ),
        ),
        endThumbIcon: Center(
          child: Text(
            controller.rangeValues.value.end.round().toString(),
            style: TextStyle(fontSize: 11.sp, fontFamily: 'Oxanium'),
          ),
        ),
        onChanged: (dynamic values) => _debounceFilterChange(() => controller.rangeValues.value = values),
      ),
    );
  }
}
