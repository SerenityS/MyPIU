import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/app/config/extension/int_format_comma.dart';
import 'package:piu_util/domain/entities/avatar_data.dart';
import 'package:piu_util/presentation/avatar/view_models/avatar_view_model.dart';
import 'package:piu_util/presentation/common/widgets/piu_card.dart';
import 'package:piu_util/presentation/common/widgets/piu_loading.dart';
import 'package:piu_util/presentation/common/widgets/piu_text_field.dart';
import 'package:piu_util/presentation/play_data/widgets/player_info_card.dart';

class AvatarView extends GetView<AvatarViewModel> {
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
                if (controller.isLoading.value) return const PIULoading("아바타 정보를 불러오는 중입니다...");

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
          if (!controller.isLoading.value) await controller.getAvatarsFromRemote();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _AvatarFilter extends GetView<AvatarViewModel> {
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
              child: Obx(() => PIUTextField(
                    isEnable: !controller.isLoading.value,
                    controller: controller.searchController,
                    onChanged: (value) => controller.filterAvatarData(),
                    hintText: "아바타명을 입력해주세요.",
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
                      value: controller.hasAvatar.value,
                      onChanged: (value) {
                        if (!controller.isLoading.value) controller.hasAvatar.value = value!;
                      },
                    ),
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

class _AvatarCard extends GetView<AvatarViewModel> {
  const _AvatarCard(this.avatar);

  final AvatarData avatar;

  @override
  Widget build(BuildContext context) {
    return PIUCard(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
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
              _buildAvatarButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarButton() {
    Color buttonColor = Colors.transparent;
    String buttonText = "";

    if (avatar.isEnable) {
      buttonColor = AppColor.enabled;
      buttonText = "사용중";
    } else if (avatar.status == "buy") {
      buttonColor = AppColor.buy;
      buttonText = "해금가능";
    } else if (avatar.status == "have") {
      buttonColor = AppColor.info;
      buttonText = "설정하기";
    } else {
      buttonColor = AppColor.error;
      buttonText = "해금불가";
    }

    return Material(
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
        splashColor: buttonColor.withOpacity(0.2),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: buttonColor),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: buttonColor),
          ),
        ),
      ),
    );
  }
}
