import 'package:get/instance_manager.dart';
import 'package:piu_util/app/network/builder/dio_builder.dart';
import 'package:piu_util/app/service/auth_service.dart';
import 'package:piu_util/app/service/my_data_service.dart';
import 'package:piu_util/app/service/play_data_service.dart';
import 'package:piu_util/data/repositories_impl/auth_repository_impl.dart';
import 'package:piu_util/data/repositories_impl/avatar_repository_impl.dart';
import 'package:piu_util/data/repositories_impl/my_data_repository_impl.dart';
import 'package:piu_util/data/repositories_impl/play_data_repository_impl.dart';
import 'package:piu_util/domain/repositories/auth_repository.dart';
import 'package:piu_util/domain/repositories/avatar_repository.dart';
import 'package:piu_util/domain/repositories/my_data_repository.dart';
import 'package:piu_util/domain/repositories/play_data_repository.dart';
import 'package:piu_util/domain/usecases/auth_usecases.dart';
import 'package:piu_util/domain/usecases/avatar_usecases.dart';
import 'package:piu_util/domain/usecases/my_data_usecases.dart';
import 'package:piu_util/domain/usecases/play_data_usecases.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    injectNetworkProvider();
    injectRepositories();
    injectServices();
    injectUseCases();
  }

  void injectNetworkProvider() {
    Get.lazyPut(() => (DioBuilder()), fenix: true);
  }

  void injectRepositories() {
    Get.put<AuthRepository>(AuthRepositoryImpl());
    Get.put<AvatarRepository>(AvatarRepositoryImpl());
    Get.put<MyDataRepository>(MyDataRepositoryImpl());
    Get.put<PlayDataRepository>(PlayDataRepositoryImpl());
  }

  void injectServices() {
    Get.put(AuthService());
    Get.lazyPut(() => MyDataService(), fenix: true);
    Get.lazyPut(() => PlayDataService(), fenix: true);
  }

  void injectUseCases() {
    Get.put(AuthUseCases());
    Get.put(AvatarUseCases());
    Get.put(MyDataUseCases());
    Get.put(PlayDataUseCases());
  }
}
