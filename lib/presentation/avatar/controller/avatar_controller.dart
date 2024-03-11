import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:piu_util/data/datasources/local/avatar_local_data_source.dart';
import 'package:piu_util/domain/entities/avatar_data.dart';
import 'package:piu_util/domain/usecases/avatar_usecases.dart';
import 'package:piu_util/presentation/home/controller/my_data_controller.dart';

class AvatarController extends GetxController {
  final AvatarUseCases _useCases = Get.find<AvatarUseCases>();
  final AvatarDataLocalDataSource _avatarDataSource = AvatarDataLocalDataSource();
  final RxBool isLoading = true.obs;

  final RxList<AvatarData> avatarDataList = <AvatarData>[].obs;
  final RxList<AvatarData> filteredAvatarList = <AvatarData>[].obs;

  final TextEditingController searchController = TextEditingController();
  final RxBool hasAvatar = false.obs;

  @override
  void onInit() async {
    super.onInit();

    List<AvatarData>? avatarData = _avatarDataSource.getAvatarData();
    if (avatarData == null) {
      await getAvatars();
    } else {
      avatarDataList.assignAll(avatarData);
      filterAvatarData();
      isLoading.value = false;
    }

    ever(avatarDataList, (_) {
      _avatarDataSource.saveAvatarData(avatarDataList);
    });
  }

  Future<void> buyAvatar(AvatarData avatar) async {
    if (await _useCases.buyAvatar.execute(avatar.id!)) {
      List<AvatarData> newAvatarList = avatarDataList.map((e) {
        if (e.name == avatar.name) {
          e = e.copyWith(status: "have");
        }
        return e;
      }).toList();

      Get.find<MyDataController>().setCoin(avatar.requiredCoin);

      avatarDataList.assignAll(newAvatarList);
      filterAvatarData();
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

  Future<void> getAvatars() async {
    isLoading.value = true;

    avatarDataList.assignAll(await _useCases.getAvatars.execute());
    _avatarDataSource.saveAvatarData(avatarDataList);
    filterAvatarData();

    isLoading.value = false;
  }

  Future<void> setAvatar(AvatarData avatar) async {
    if (await _useCases.setAvatar.execute(avatar.id!)) {
      List<AvatarData> newAvatarList = avatarDataList.map((e) {
        if (e.name == avatar.name) {
          e = e.copyWith(isEnable: true);
        } else if (e.isEnable) {
          e = e.copyWith(isEnable: false);
        }
        return e;
      }).toList();

      Get.find<MyDataController>().setAvatar(avatar.fileName);

      avatarDataList.assignAll(newAvatarList);
      filterAvatarData();

      Fluttertoast.showToast(msg: "아바타를 설정했습니다.");
    } else {
      Fluttertoast.showToast(msg: "아바타 설정에 실패했습니다.");
    }
  }
}
