import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/service/my_data_service.dart';
import 'package:piu_util/data/datasources/local/title_local_data_source.dart';
import 'package:piu_util/domain/entities/title_data.dart';
import 'package:piu_util/domain/usecases/my_data_usecases.dart';

class TitleViewModel extends GetxController {
  // Data Source
  final MyDataUseCases _useCases = Get.find<MyDataUseCases>();
  final TitleLocalDataSource _titleLocalDataSource = TitleLocalDataSource();
  RxBool isLoading = false.obs;

  // Title Data
  final RxList<TitleData> _titleDataList = <TitleData>[].obs;
  final RxList<TitleData> filteredTitleDataList = <TitleData>[].obs;

  // Filter
  final TextEditingController searchController = TextEditingController();
  final RxBool hasTitle = false.obs;

  @override
  void onInit() async {
    super.onInit();

    ever(_titleDataList, (_) {
      _titleLocalDataSource.saveTitleData(_titleDataList);
      filterTitleData();
    });

    getTitleDataFromLocal();
    if (_titleDataList.isNotEmpty) {
      if (MyDataService.to.myData.titleText != _titleDataList.firstWhere((element) => element.isEnable).titleText) {
        await getTitleDataFromRemote();
      }
    } else {
      await getTitleDataFromRemote();
    }
  }

  void filterTitleData() {
    filteredTitleDataList.assignAll(
      _titleDataList.where(
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

  void getTitleDataFromLocal() {
    _titleDataList.assignAll(_titleLocalDataSource.getTitleData());
    filteredTitleDataList.assignAll(_titleDataList);
  }

  Future<void> getTitleDataFromRemote() async {
    isLoading(true);
    _titleDataList.assignAll(await _useCases.getTitleData.execute());
    isLoading(false);
  }

  Future<void> setTitle(TitleData title) async {
    bool result = await _useCases.setTitle.execute(title.id!);

    if (result) {
      MyDataService.to.setTitle(title);

      List<TitleData> updatedTitleDataList = _titleDataList.map((e) {
        if (e.titleText == title.titleText) {
          e = e.copyWith(isEnable: true);
        } else if (e.isEnable) {
          e = e.copyWith(isEnable: false);
        }
        return e;
      }).toList();

      _titleDataList.assignAll(updatedTitleDataList);

      Fluttertoast.showToast(msg: "칭호가 변경되었습니다.");
    } else {
      Fluttertoast.showToast(msg: "칭호 변경에 실패했습니다.");
    }
  }
}
