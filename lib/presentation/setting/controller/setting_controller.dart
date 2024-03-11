import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:piu_util/app/config/routes/route_path.dart';
import 'package:piu_util/data/datasources/local/auth_local_data_source.dart';
import 'package:piu_util/domain/usecases/auth_usecases.dart';

class SettingController extends GetxController {
  final RxString appVersion = "1.0.0".obs;
  final RxString assetVersion = "1.07.0".obs;

  @override
  void onInit() async {
    super.onInit();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
  }

  Future<void> logout() async {
    await Get.find<AuthUseCases>().logout.execute();
    await AuthLocalDataSource().deleteCredential();
    await Hive.deleteFromDisk();

    Get.offAllNamed(RoutePath.login);
  }
}