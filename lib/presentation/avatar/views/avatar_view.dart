import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GridView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 0, childAspectRatio: 0.85),
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
        onPressed: () async => await controller.getAvatars(),
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
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
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
                  hintText: "아바타명을 입력해주세요.",
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                onChanged: (value) => controller.filterAvatarData(),
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
                        value: controller.hasAvatar.value,
                        onChanged: (value) {
                          controller.hasAvatar.value = value!;
                          controller.filterAvatarData();
                        }),
                  ),
                  const Text("보유 아바타"),
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
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.cardPrimary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset('assets/avatar/${avatar.fileName}'),
          ),
          const SizedBox(height: 4),
          FittedBox(child: Text(avatar.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          const SizedBox(height: 4),
          Row(
            children: [
              if (avatar.requiredCoin > 0) ...[
                SvgPicture.asset('assets/icon/coin.svg', width: 14, height: 14),
                const SizedBox(width: 4),
                Text(avatar.requiredCoin.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400)),
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
                  borderRadius: BorderRadius.circular(6),
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
                      borderRadius: BorderRadius.circular(6),
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
                          fontSize: 11,
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
