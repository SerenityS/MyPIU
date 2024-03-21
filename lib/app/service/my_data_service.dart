import 'package:get/get.dart';
import 'package:piu_util/domain/entities/my_data.dart';
import 'package:piu_util/domain/entities/title_data.dart';
import 'package:piu_util/domain/usecases/my_data_usecases.dart';

class MyDataService extends GetxService {
  static MyDataService get to => Get.find<MyDataService>();

  final MyDataUseCases _myDataUseCases = Get.find<MyDataUseCases>();
  final RxList<MyData> _myDataList = <MyData>[].obs;
  MyData get myData => _myDataList[0];

  Future<void> getMyDataList() async {
    try {
      _myDataList.assignAll(await _myDataUseCases.getMyData.execute());
    } catch (e) {
      _myDataList.assignAll([]);
    }
  }

  void setAvatar(String avatar) {
    _myDataList[0] = _myDataList[0].copyWith(avatar: avatar);
  }

  void setCoin(int coin) {
    _myDataList[0] = _myDataList[0].copyWith(coin: _myDataList[0].coin - coin);
  }

  void setTitle(TitleData titleData) {
    _myDataList[0] = _myDataList[0].copyWith(titleText: titleData.titleText, titleType: titleData.titleType);
  }
}
