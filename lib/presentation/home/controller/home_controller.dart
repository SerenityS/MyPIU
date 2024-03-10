import 'package:get/get.dart';
import 'package:piu_util/domain/entities/my_data.dart';
import 'package:piu_util/domain/usecases/my_data_usecases.dart';

class HomeController extends GetxController {
  final MyDataUseCases _myDataUseCases = Get.find<MyDataUseCases>();
  final RxBool isLoading = true.obs;

  final RxInt _userIdx = 0.obs;
  final RxList<MyData> _myDataList = <MyData>[].obs;

  MyData get myData => _myDataList[_userIdx.value];

  @override
  onInit() async {
    super.onInit();

    await getMyData();
  }

  Future<void> getMyData() async {
    isLoading.value = true;
    _myDataList.assignAll(await _myDataUseCases.getMyData.execute());
    isLoading.value = false;
  }
}
