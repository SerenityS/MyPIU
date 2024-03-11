import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:piu_util/app/config/app_typeface.dart';
import 'package:piu_util/app/config/extension/int_format_comma.dart';
import 'package:piu_util/domain/entities/recently_play_data.dart';
import 'package:piu_util/domain/enum/judge_type.dart';
import 'package:piu_util/presentation/common/widgets/judge_text.dart';
import 'package:piu_util/presentation/common/widgets/step_ball.dart';

import '../controller/recently_play_data_controller.dart';

class RecentlyPlayDataView extends GetView<RecentlyPlayDataController> {
  const RecentlyPlayDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              }

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.recentlyPlayData.length,
                itemBuilder: (BuildContext context, int index) {
                  return _RecentlyPlayCard(
                    controller.recentlyPlayData[index],
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await controller.getRecentlyPlayData(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _RecentlyPlayCard extends StatelessWidget {
  const _RecentlyPlayCard(this.data);

  final RecentlyPlayData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          image: AssetImage('assets/jacket/${data.jacketFileName}'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StepBall(chartType: data.chartType, level: data.level),
              Column(
                children: [
                  if (data.gradeType != null) Image.asset('assets/grade/${data.gradeType!.fileName}', height: 35),
                  Text(data.score?.formatWithComma() ?? "STAGE BREAK", style: AppTypeFace.judge.copyWith(fontSize: 14)),
                ],
              ),
              if (data.plateType != null) Image.asset('assets/plate/${data.plateType!.fileName}', height: 40),
            ],
          ),
          const SizedBox(height: 6),
          _JudgeCard(data: data)
        ],
      ),
    );
  }
}

class _JudgeCard extends StatelessWidget {
  const _JudgeCard({required this.data});

  final RecentlyPlayData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            const JudgeText(JudgeType.Perfect),
            const SizedBox(height: 4),
            Text(data.perfect.formatWithComma(), style: AppTypeFace.judge)
          ]),
          Column(children: [
            const JudgeText(JudgeType.Great),
            const SizedBox(height: 4),
            Text(data.great.formatWithComma(), style: AppTypeFace.judge)
          ]),
          Column(children: [
            const JudgeText(JudgeType.Good),
            const SizedBox(height: 4),
            Text(data.good.formatWithComma(), style: AppTypeFace.judge)
          ]),
          Column(children: [
            const JudgeText(JudgeType.Bad),
            const SizedBox(height: 4),
            Text(data.bad.formatWithComma(), style: AppTypeFace.judge)
          ]),
          Column(children: [
            const JudgeText(JudgeType.Miss),
            const SizedBox(height: 4),
            Text(data.miss.formatWithComma(), style: AppTypeFace.judge)
          ]),
        ],
      ),
    );
  }
}
