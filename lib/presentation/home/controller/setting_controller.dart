import 'package:get/get.dart';
import 'package:piu_util/app/config/routes/route_path.dart';
import 'package:piu_util/data/datasources/local/auth_local_data_source.dart';
import 'package:piu_util/domain/usecases/auth_usecases.dart';

class SettingController extends GetxController {
  Future<void> logout() async {
    await Get.find<AuthUseCases>().logout.execute();
    await AuthLocalDataSource().deleteCredential();

    Get.offAndToNamed(RoutePath.login);
  }
}
