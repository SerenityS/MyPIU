import 'package:get/instance_manager.dart';
import 'package:piu_util/app/network/builder/dio_builder.dart';
import 'package:piu_util/app/service/auth_service.dart';
import 'package:piu_util/data/datasources/repositories_impl/auth_repository_impl.dart';
import 'package:piu_util/domain/repositories/auth_repository.dart';
import 'package:piu_util/domain/usecases/auth_usecases.dart';

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
  }

  void injectServices() {
    Get.put(AuthService());
  }

  void injectUseCases() {
    Get.put(AuthUseCases());
  }
}
