import 'package:get/get.dart';
import 'package:piu_util/domain/entities/recently_play_data.dart';
import 'package:piu_util/domain/usecases/play_data_usecases.dart';

class RecentlyPlayDataViewModel extends GetxController {
  final PlayDataUseCases _useCases = Get.find<PlayDataUseCases>();
  final RxBool isLoading = true.obs;

  final RxList<RecentlyPlayData> recentlyPlayData = <RecentlyPlayData>[].obs;

  @override
  void onInit() async {
    super.onInit();

    await getRecentlyPlayData();
  }

  Future<void> getRecentlyPlayData() async {
    isLoading.value = true;
    recentlyPlayData.assignAll(await _useCases.getRecentlyPlayData.execute());
    isLoading.value = false;
  }
}
