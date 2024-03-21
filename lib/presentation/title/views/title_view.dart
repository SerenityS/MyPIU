import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/domain/entities/title_data.dart';
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
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

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
              child: Obx(
                () => TextField(
                  enabled: !controller.isLoading.value,
                  controller: controller.searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
                    filled: true,
                    fillColor: AppColor.input,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "칭호명을 입력해주세요.",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) => controller.filterTitleData(),
                  onTapOutside: (PointerDownEvent event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
              ),
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
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColor.cardPrimary,
      ),
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                if (title.isEnable || !title.hasTitle) return;

                await controller.setTitle(title);
              },
              borderRadius: BorderRadius.circular(8.r),
              highlightColor: Colors.transparent,
              splashColor: title.isEnable
                  ? AppColor.enabled.withOpacity(0.2)
                  : title.hasTitle
                      ? AppColor.info.withOpacity(0.4)
                      : AppColor.error.withOpacity(0.2),
              child: Container(
                alignment: Alignment.center,
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 8.w),
                decoration: BoxDecoration(
                  border: title.isEnable
                      ? Border.all(color: AppColor.enabled)
                      : title.hasTitle
                          ? Border.all(color: AppColor.info)
                          : Border.all(color: AppColor.error),
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.transparent,
                ),
                child: Text(
                  title.isEnable
                      ? "칭호 사용중"
                      : title.hasTitle
                          ? "설정하기"
                          : "해금 조건 미달",
                  style: TextStyle(
                    color: title.isEnable
                        ? AppColor.enabled
                        : title.hasTitle
                            ? AppColor.info
                            : AppColor.error,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
