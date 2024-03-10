import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/domain/entities/title_data.dart';
import 'package:piu_util/presentation/common/widgets/title_text.dart';
import 'package:piu_util/presentation/home/widgets/player_info_card.dart';

import '../controller/title_controller.dart';

class TitleView extends GetView<TitleController> {
  const TitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              const PlayerInfoCard(),
              const _TitleFilter(),
              Obx(() {
                if (controller.isLoading.value) {
                  return Padding(
                    padding: EdgeInsets.only(top: Get.width * 0.1),
                    child: const CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.filteredTitleDataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _TitleCard(controller.filteredTitleDataList[index]);
                  },
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await controller.getTitleData(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _TitleFilter extends GetView<TitleController> {
  const _TitleFilter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  filled: true,
                  fillColor: AppColor.input,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "칭호명을 입력해주세요.",
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                onChanged: (value) => controller.filterTitleData(),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColor.input,
              ),
              child: Row(
                children: [
                  Obx(
                    () => Checkbox(
                        value: controller.hasTitle.value,
                        onChanged: (value) {
                          controller.hasTitle.value = value!;
                          controller.filterTitleData();
                        }),
                  ),
                  const Text("보유 칭호"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TitleCard extends GetView<TitleController> {
  const _TitleCard(this.title);

  final TitleData title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.cardPrimary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(child: TitleText(title.titleText, title.titleType)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Expanded(child: Text(title.description, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
            ],
          ),
          const SizedBox(height: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                if (title.isEnable || !title.hasTitle) return;

                await controller.setTitle(title);
              },
              borderRadius: BorderRadius.circular(8),
              highlightColor: Colors.transparent,
              splashColor: title.isEnable
                  ? AppColor.enabled.withOpacity(0.2)
                  : title.hasTitle
                      ? AppColor.info.withOpacity(0.4)
                      : AppColor.error.withOpacity(0.2),
              child: Container(
                alignment: Alignment.center,
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: title.isEnable
                      ? Border.all(color: AppColor.enabled)
                      : title.hasTitle
                          ? Border.all(color: AppColor.info)
                          : Border.all(color: AppColor.error),
                  borderRadius: BorderRadius.circular(8),
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
