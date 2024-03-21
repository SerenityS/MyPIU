import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/service/my_data_service.dart';
import 'package:piu_util/data/datasources/local/avatar_local_data_source.dart';
import 'package:piu_util/domain/entities/avatar_data.dart';
import 'package:piu_util/domain/usecases/avatar_usecases.dart';

class AvatarViewModel extends GetxController {
  // Data Source
  final AvatarUseCases _useCases = Get.find<AvatarUseCases>();
  final AvatarDataLocalDataSource _avatarDataSource = AvatarDataLocalDataSource();
  final RxBool isLoading = false.obs;

  // Avatar Data
  final RxList<AvatarData> avatarDataList = <AvatarData>[].obs;
  final RxList<AvatarData> filteredAvatarList = <AvatarData>[].obs;

  // Filter
  final TextEditingController searchController = TextEditingController();
  final RxBool hasAvatar = false.obs;

  @override
  void onInit() async {
    super.onInit();

    ever(avatarDataList, (_) {
      _avatarDataSource.saveAvatarData(avatarDataList);
      filterAvatarData();
    });

    getAvatarDataFromLocal();
    if (avatarDataList.isNotEmpty) {
      if (MyDataService.to.myData.avatar != avatarDataList.firstWhere((element) => element.isEnable).fileName) {
        await getAvatarsFromRemote();
      }
    } else {
      await getAvatarsFromRemote();
    }
  }

  Future<void> buyAvatar(AvatarData avatar) async {
    bool result = await _useCases.buyAvatar.execute(avatar.id!);

    if (result) {
      MyDataService.to.setCoin(avatar.requiredCoin);

      List<AvatarData> newAvatarList = avatarDataList.map((e) {
        if (e.name == avatar.name) {
          e = e.copyWith(status: "have");
        }
        return e;
      }).toList();

      avatarDataList.assignAll(newAvatarList);
      Fluttertoast.showToast(msg: "아바타를 구매했습니다.");
    } else {
      Fluttertoast.showToast(msg: "아바타 구매에 실패했습니다.");
    }
  }

  void filterAvatarData() {
    filteredAvatarList.assignAll(
      avatarDataList.where(
        (element) {
          final titleContainsSearchText =
              element.name.toLowerCase().replaceAll(' ', '').contains(searchController.text.toLowerCase().replaceAll(' ', ''));

          if (hasAvatar.value) {
            return element.status == "have" && (searchController.text.isEmpty || titleContainsSearchText);
          } else {
            return searchController.text.isEmpty || titleContainsSearchText;
          }
        },
      ),
    );
  }

  void getAvatarDataFromLocal() {
    avatarDataList.assignAll(_avatarDataSource.getAvatarData());
    filteredAvatarList.assignAll(avatarDataList);
  }

  Future<void> getAvatarsFromRemote() async {
    isLoading(true);
    avatarDataList.assignAll(await _useCases.getAvatars.execute());
    isLoading(false);
  }

  Future<void> setAvatar(AvatarData avatar) async {
    bool result = await _useCases.setAvatar.execute(avatar.id!);

    if (result) {
      MyDataService.to.setAvatar(avatar.fileName);

      List<AvatarData> newAvatarList = avatarDataList.map((e) {
        if (e.name == avatar.name) {
          e = e.copyWith(isEnable: true);
        } else if (e.isEnable) {
          e = e.copyWith(isEnable: false);
        }
        return e;
      }).toList();

      avatarDataList.assignAll(newAvatarList);

      Fluttertoast.showToast(msg: "아바타를 설정했습니다.");
    } else {
      Fluttertoast.showToast(msg: "아바타 설정에 실패했습니다.");
    }
  }
}
