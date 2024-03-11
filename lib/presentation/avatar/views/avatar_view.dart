import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/app/config/extension/int_format_comma.dart';
import 'package:piu_util/domain/entities/avatar_data.dart';
import 'package:piu_util/presentation/avatar/controller/avatar_controller.dart';
import 'package:piu_util/presentation/home/widgets/player_info_card.dart';

class AvatarView extends GetView<AvatarController> {
  const AvatarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PlayerInfoCard(showCoin: true),
          const _AvatarFilter(),
          Expanded(
            child: Obx(
              () {
                if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: GridView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 0, childAspectRatio: 0.8),
                    itemCount: controller.filteredAvatarList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _AvatarCard(controller.filteredAvatarList[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (controller.isLoading.value) return;

          await controller.getAvatars();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _AvatarFilter extends GetView<AvatarController> {
  const _AvatarFilter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
      child: SizedBox(
        height: 40.w,
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
                    hintText: "아바타명을 입력해주세요.",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) => controller.filterAvatarData(),
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
                        value: controller.hasAvatar.value,
                        onChanged: (value) {
                          if (controller.isLoading.value) return;

                          controller.hasAvatar.value = value!;
                          controller.filterAvatarData();
                        }),
                  ),
                  const Text("보유 아바타", style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _AvatarCard extends GetView<AvatarController> {
  const _AvatarCard(this.avatar);

  final AvatarData avatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColor.cardPrimary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Image.asset('assets/avatar/${avatar.fileName}'),
          ),
          SizedBox(height: 4.h),
          FittedBox(child: Text(avatar.name, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold))),
          SizedBox(height: 4.h),
          Row(
            children: [
              if (avatar.requiredCoin > 0) ...[
                SvgPicture.asset('assets/icon/coin.svg', width: 14.w, height: 14.w),
                SizedBox(width: 4.w),
                Text(avatar.requiredCoin.formatWithComma(), style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400)),
              ],
              const Spacer(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    if (avatar.isEnable || avatar.status == "not") {
                      return;
                    } else if (avatar.status == "buy") {
                      await controller.buyAvatar(avatar);
                    } else if (avatar.status == "have") {
                      await controller.setAvatar(avatar);
                    }
                  },
                  borderRadius: BorderRadius.circular(6.r),
                  highlightColor: Colors.transparent,
                  splashColor: avatar.isEnable
                      ? AppColor.enabled.withOpacity(0.2)
                      : avatar.status == "buy"
                          ? AppColor.buy.withOpacity(0.2)
                          : avatar.status == "have"
                              ? AppColor.info.withOpacity(0.4)
                              : AppColor.error.withOpacity(0.2),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      border: avatar.isEnable
                          ? Border.all(color: AppColor.enabled)
                          : avatar.status == "buy"
                              ? Border.all(color: AppColor.buy)
                              : avatar.status == "have"
                                  ? Border.all(color: AppColor.info)
                                  : Border.all(color: AppColor.error),
                      borderRadius: BorderRadius.circular(6.r),
                      color: Colors.transparent,
                    ),
                    child: Text(
                      avatar.isEnable
                          ? "사용중"
                          : avatar.status == "buy"
                              ? "해금가능"
                              : avatar.status == "have"
                                  ? "설정하기"
                                  : "해금불가",
                      style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: avatar.isEnable
                              ? AppColor.enabled
                              : avatar.status == "buy"
                                  ? AppColor.buy
                                  : avatar.status == "have"
                                      ? AppColor.info
                                      : AppColor.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
