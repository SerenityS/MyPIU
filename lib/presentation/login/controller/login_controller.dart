import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/routes/route_path.dart';
import 'package:piu_util/data/datasources/local/auth_local_data_source.dart';
import 'package:piu_util/domain/entities/login_entity.dart';
import 'package:piu_util/domain/usecases/auth_usecases.dart';

class LoginController extends GetxController {
  final AuthUseCases _useCases = Get.find<AuthUseCases>();
  final AuthLocalDataSource _authDataSource = AuthLocalDataSource();
  RxBool isLoading = false.obs;

  LoginEntity? _credendtial;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();

    await _getCredential();
    if (_credendtial != null) {
      emailController.text = _credendtial!.email;
      passwordController.text = _credendtial!.password;
      await login();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> _deleteCredential() async {
    await _authDataSource.deleteCredential();
  }

  Future<void> _getCredential() async {
    _credendtial = await _authDataSource.getCredential();
  }

  Future<void> _saveCredential() async {
    await _authDataSource.saveCredential(
      LoginEntity(email: emailController.text, password: passwordController.text),
    );
  }

  Future<void> login() async {
    isLoading.value = true;

    final result = await _useCases.login.execute(
      LoginEntity(email: emailController.text, password: passwordController.text),
    );

    if (result) {
      await _saveCredential();
      Get.offAllNamed(RoutePath.playData);
    } else {
      Get.snackbar('Error', 'Login Failed');
      await _deleteCredential();
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _useCases.logout.execute();
    await _deleteCredential();
  }
}