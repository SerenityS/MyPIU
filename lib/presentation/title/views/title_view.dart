import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/domain/entities/title_data.dart';
import 'package:piu_util/presentation/common/widgets/piu_card.dart';
import 'package:piu_util/presentation/common/widgets/piu_loading.dart';
import 'package:piu_util/presentation/common/widgets/piu_text_field.dart';
import 'package:piu_util/presentation/common/widgets/title_text.dart';
import 'package:piu_util/presentation/play_data/widgets/player_info_card.dart';

import '../view_models/title_view_model.dart';

class TitleView extends GetView<TitleViewModel> {
  const TitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PlayerInfoCard(),
            const _TitleFilter(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) return const PIULoading("칭호 정보를 불러오는 중입니다...");

                return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.filteredTitleDataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _TitleCard(controller.filteredTitleDataList[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (controller.isLoading.value) return;

          await controller.getTitleDataFromRemote();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _TitleFilter extends GetView<TitleViewModel> {
  const _TitleFilter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
      child: SizedBox(
        height: 40.h,
        child: Row(
          children: [
            Expanded(
              child: Obx(() => PIUTextField(
                    isEnable: !controller.isLoading.value,
                    controller: controller.searchController,
                    onChanged: (value) => controller.filteredTitleDataList,
                    hintText: "칭호명을 입력해주세요.",
                  )),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.only(right: 14.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColor.input,
              ),
              child: Row(
                children: [
                  Obx(
                    () => Checkbox(
                        value: controller.hasTitle.value,
                        onChanged: (value) {
                          if (controller.isLoading.value) return;

                          controller.hasTitle.value = value!;
                          controller.filterTitleData();
                        }),
                  ),
                  const Text("보유 칭호", style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TitleCard extends GetView<TitleViewModel> {
  const _TitleCard(this.title);

  final TitleData title;

  @override
  Widget build(BuildContext context) {
    return PIUCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(child: TitleText(title.titleText, title.titleType)),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white, size: 16.w),
              SizedBox(width: 4.w),
              Expanded(child: Text(title.description, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500))),
            ],
          ),
          SizedBox(height: 8.h),
          _buildTitleButton(),
        ],
      ),
    );
  }

  Widget _buildTitleButton() {
    Color buttonColor = Colors.transparent;
    String buttonText = "";

    if (title.isEnable) {
      buttonColor = AppColor.enabled;
      buttonText = "칭호 사용중";
    } else if (title.hasTitle) {
      buttonColor = AppColor.info;
      buttonText = "설정하기";
    } else {
      buttonColor = AppColor.error;
      buttonText = "해금 조건 미달";
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (title.isEnable || !title.hasTitle) return;

          await controller.setTitle(title);
        },
        borderRadius: BorderRadius.circular(8.r),
        highlightColor: Colors.transparent,
        splashColor: buttonColor.withOpacity(0.2),
        child: Container(
          alignment: Alignment.center,
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 8.w),
          decoration: BoxDecoration(
            border: Border.all(color: buttonColor),
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.transparent,
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: buttonColor,
            ),
          ),
        ),
      ),
    );
  }
}
