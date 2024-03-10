import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:piu_util/domain/entities/title_data.dart';
import 'package:piu_util/domain/usecases/my_data_usecases.dart';
import 'package:piu_util/presentation/home/controller/my_data_controller.dart';

class TitleController extends GetxController {
  final MyDataUseCases _useCases = Get.find<MyDataUseCases>();
  RxBool isLoading = true.obs;

  final RxList<TitleData> titleDataList = <TitleData>[].obs;
  final RxList<TitleData> filteredTitleDataList = <TitleData>[].obs;

  final TextEditingController searchController = TextEditingController();
  final RxBool hasTitle = false.obs;

  @override
  void onInit() async {
    super.onInit();

    await getTitleData();
  }

  void filterTitleData() {
    filteredTitleDataList.assignAll(
      titleDataList.where(
        (element) {
          final titleContainsSearchText =
              element.titleText.toLowerCase().replaceAll(' ', '').contains(searchController.text.toLowerCase().replaceAll(' ', ''));

          if (hasTitle.value) {
            return element.hasTitle && (searchController.text.isEmpty || titleContainsSearchText);
          } else {
            return searchController.text.isEmpty || titleContainsSearchText;
          }
        },
      ),
    );
  }

  Future<void> getTitleData() async {
    titleDataList.assignAll(await _useCases.getTitleData.execute());
    filteredTitleDataList.assignAll(titleDataList);
    isLoading.value = false;
  }

  Future<void> setTitle(TitleData title) async {
    bool result = await _useCases.setTitle.execute(title.id!);

    if (result) {
      Get.find<MyDataController>().setTitle(title);

      List<TitleData> updatedTitleDataList = titleDataList.map((e) {
        if (e.titleText == title.titleText) {
          e = e.copyWith(isEnable: true);
        } else if (e.isEnable) {
          e = e.copyWith(isEnable: false);
        }
        return e;
      }).toList();

      titleDataList.assignAll(updatedTitleDataList);
      filterTitleData();

      Fluttertoast.showToast(msg: "칭호가 변경되었습니다.");
    } else {
      Fluttertoast.showToast(msg: "칭호 변경에 실패했습니다.");
    }
  }
}
