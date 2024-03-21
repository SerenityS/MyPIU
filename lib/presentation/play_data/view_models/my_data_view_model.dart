import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/service/my_data_service.dart';
import 'package:piu_util/app/service/play_data_service.dart';
import 'package:piu_util/domain/entities/chart_data.dart';
import 'package:piu_util/domain/entities/my_data.dart';
import 'package:piu_util/domain/enum/chart_type.dart';
import 'package:piu_util/domain/enum/plate_type.dart';

class MyDataViewModel extends GetxController {
  // Data
  MyData get myData => MyDataService.to.myData;
  List<ChartData> get clearDataList => PlayDataService.to.clearDataList;

  final RxBool isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();

    await _getMyData();

    // Get Clear Data from LocalDataSource
    PlayDataService.to.getClearDataFromLocal();

    if (clearDataList.isEmpty) {
      // Get Clear Data from RemoteDataSource
      await _getClearDataFromRemote();
    } else {
      // Check if there is new clear data
      // when the user's total clear count is different from the local data
      int totalClearCount = clearDataList.where((element) => element.level >= 10).length;

      if (totalClearCount != MyDataService.to.myData.totalClear) {
        Fluttertoast.showToast(msg: "새로운 클리어 정보가 있습니다.\n클리어 정보를 갱신합니다.");
        await _getClearDataFromRemote();
      }
    }
  }

  Future<void> _getMyData() async {
    isLoading(true);
    await MyDataService.to.getMyDataList();
    isLoading(false);
  }

  Future<void> _getClearDataFromRemote() async {
    isLoading(true);
    await PlayDataService.to.getClearDataFromRemote();
    isLoading(false);
  }

  int getMaxLevelForType(List<ChartData> dataList, PlateType plateType, ChartType chartType) {
    return dataList
        .where((element) => element.plateType == plateType && element.chartType == chartType)
        .fold<int>(0, (highest, element) => highest > element.level ? highest : element.level);
  }
}
