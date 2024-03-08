import 'package:get/get.dart';

import '../entities/login_entity.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository _repository = Get.find<AuthRepository>();

  LoginUseCase get login => LoginUseCase(_repository);
  LogoutUseCase get logout => LogoutUseCase(_repository);
}

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<bool> execute(LoginEntity loginEntity) async {
    return await _repository.login(loginEntity);
  }
}

class LogoutUseCase {
  final AuthRepository _repository;
  LogoutUseCase(this._repository);

  Future<void> execute() async {
    await _repository.logout();
  }
}
