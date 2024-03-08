import '../entities/login_entity.dart';

abstract class AuthRepository {
  Future<bool> login(LoginEntity loginEntity);
  Future<void> logout();
}
