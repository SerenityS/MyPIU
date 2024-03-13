import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/app/config/app_typeface.dart';
import 'package:piu_util/app/config/extension/ensure_visible.dart';
import 'package:piu_util/app/config/extension/int_format_comma.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/entities/rating_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/enum/grade_type.dart';
import 'package:piu_util/presentation/play_data/controller/rating_controller.dart';

class RatingView extends GetView<RatingController> {
  const RatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.ratingDataList.isEmpty) {
        return Center(child: Text("플레이 정보가 없습니다.\n게임을 플레이해주세요.", style: AppTypeFace().loading));
      }

      return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: controller.ratingDataList.length,
        itemBuilder: (BuildContext context, int index) {
          final RatingData data = controller.ratingDataList[index];
          final GlobalKey containerKey = GlobalKey();

          if (index < 10) return const SizedBox();
          if (data.clearData.isEmpty) return const SizedBox();

          return Container(
            key: containerKey,
            margin: EdgeInsets.symmetric(vertical: 4.w, horizontal: 12.w),
            padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
            decoration: BoxDecoration(color: AppColor.cardPrimary, borderRadius: BorderRadius.circular(12.r)),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                onExpansionChanged: (value) {
                  if (value) containerKey.ensureVisible();
                },
                title: Text("Lv. ${index + 1}", style: TextStyle(fontSize: 25.sp, fontFamily: 'Oxanium', color: Colors.white)),
                tilePadding: EdgeInsets.zero,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 18.sp, fontFamily: 'Oxanium'),
                          children: [
                            TextSpan(
                              text: "Rating: ${(data.singleRating + data.doubleRating).formatWithComma()}\n",
                            ),
                            TextSpan(
                              text: "Clear: ${data.clearData.length}(",
                            ),
                            TextSpan(
                              text: data.singleCount.toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
                            const TextSpan(text: "+"),
                            TextSpan(
                              text: data.doubleCount.toString(),
                              style: const TextStyle(color: Colors.green),
                            ),
                            TextSpan(text: ") / ${controller.singleChartCount[index] + controller.doubleChartCount[index]}"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(12.r)),
                        padding: EdgeInsets.symmetric(vertical: 4.w),
                        child: Column(
                          children: [
                            Text("Grade Info", style: TextStyle(fontSize: 20.sp, fontFamily: 'Oxanium')),
                            SizedBox(height: 8.w),
                            GradeTypeBarChart(ratingData: controller.ratingDataList[index]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

class GradeTypeBarChart extends StatefulWidget {
  final RatingData ratingData;

  const GradeTypeBarChart({super.key, required this.ratingData});

  @override
  State<GradeTypeBarChart> createState() => _GradeTypeBarChartState();
}

class _GradeTypeBarChartState extends State<GradeTypeBarChart> {
  late Map<GradeType, int> gradeTypeCounts;

  @override
  void initState() {
    super.initState();
  }

  Map<GradeType, Map<ChartType, double>> aggregateData(List<ChartData> data) {
    Map<GradeType, Map<ChartType, double>> aggregatedData = {};
    for (var chartData in data) {
      aggregatedData.putIfAbsent(chartData.gradeType, () => {})[chartData.chartType] =
          (aggregatedData[chartData.gradeType]?[chartData.chartType] ?? 0) + 1;
    }

    aggregatedData = Map.fromEntries(aggregatedData.entries.toList()
      ..sort((a, b) => b.value.values
          .fold(0, (prev, element) => prev.toInt() + element.toInt())
          .compareTo(a.value.values.fold(0, (prev, element) => prev + element))));

    return aggregatedData;
  }

  @override
  Widget build(BuildContext context) {
    final aggregatedData = aggregateData(widget.ratingData.clearData);

    return SizedBox(
      height: 100.w,
      child: BarChart(
        BarChartData(
          minY: 0,
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  "${GradeType.values[group.x.toInt()].name.replaceAll("p", "+")}\n"
                  "Single: ${aggregatedData[GradeType.values[group.x.toInt()]]?[ChartType.SINGLE]?.toInt().toString() ?? "0"}\n"
                  "Double: ${aggregatedData[GradeType.values[group.x.toInt()]]?[ChartType.DOUBLE]?.toInt().toString() ?? "0"}",
                  TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: 'Oxanium',
                  ),
                  textAlign: TextAlign.start,
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30.w,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      meta.formattedValue,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: 'Oxanium',
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(GradeType.values[value.toInt()].name.replaceAll("p", "+"),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'Oxanium',
                    )),
              ),
            ),
          ),
          barGroups: [
            for (var gradeData in aggregatedData.keys)
              BarChartGroupData(
                x: gradeData.index,
                barRods: [
                  if (aggregatedData[gradeData] != null)
                    BarChartRodData(
                      width: 10.w,
                      color: (aggregatedData[gradeData]?[ChartType.SINGLE] ?? 0) == 0 ? Colors.green : Colors.red,
                      toY: (aggregatedData[gradeData]?[ChartType.SINGLE] ?? 0) + (aggregatedData[gradeData]?[ChartType.DOUBLE] ?? 0),
                      rodStackItems: [
                        if ((aggregatedData[gradeData]?[ChartType.SINGLE] ?? 0) > (aggregatedData[gradeData]?[ChartType.DOUBLE] ?? 0)) ...[
                          if (aggregatedData[gradeData]![ChartType.DOUBLE] != null)
                            BarChartRodStackItem(
                              0,
                              aggregatedData[gradeData]![ChartType.DOUBLE]!,
                              Colors.green,
                            ),
                          if (aggregatedData[gradeData]![ChartType.SINGLE] != null)
                            BarChartRodStackItem(
                              (aggregatedData[gradeData]?[ChartType.DOUBLE] ?? 0),
                              aggregatedData[gradeData]![ChartType.SINGLE]! + (aggregatedData[gradeData]?[ChartType.DOUBLE] ?? 0),
                              Colors.red,
                            ),
                        ] else ...[
                          if (aggregatedData[gradeData]![ChartType.SINGLE] != null)
                            BarChartRodStackItem(
                              0,
                              aggregatedData[gradeData]![ChartType.SINGLE]!,
                              Colors.red,
                            ),
                          if (aggregatedData[gradeData]![ChartType.DOUBLE] != null)
                            BarChartRodStackItem(
                              (aggregatedData[gradeData]?[ChartType.SINGLE] ?? 0),
                              aggregatedData[gradeData]![ChartType.DOUBLE]! + (aggregatedData[gradeData]?[ChartType.SINGLE] ?? 0),
                              Colors.green,
                            ),
                        ]
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
