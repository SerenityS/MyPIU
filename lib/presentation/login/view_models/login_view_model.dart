import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piu_util/data/datasources/local/auth_local_data_source.dart';
import 'package:piu_util/domain/entities/login_entity.dart';
import 'package:piu_util/domain/usecases/auth_usecases.dart';

class LoginViewModel extends GetxController {
  // UseCases & DataSource
  final AuthUseCases _useCases = Get.find<AuthUseCases>();
  final AuthLocalDataSource _authDataSource = AuthLocalDataSource();

  // Credential
  LoginEntity? _credendtial;

  // Login Status
  RxBool isLoading = false.obs;
  RxBool isAuthenticated = false.obs;

  // View
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();

    if (await _getCredential()) {
      emailController.text = _credendtial!.email;
      passwordController.text = _credendtial!.password;

      await login();
    }
  }

  Future<bool> _deleteCredential() async {
    try {
      await _authDataSource.deleteCredential();
      return true;
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return false;
    }
  }

  Future<bool> _getCredential() async {
    try {
      _credendtial = await _authDataSource.getCredential();
      return true;
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return false;
    }
  }

  Future<void> _saveCredential() async {
    await _authDataSource.saveCredential(
      LoginEntity(email: emailController.text, password: passwordController.text),
    );
  }

  Future<bool> login() async {
    if (formKey.currentState!.validate() == false) return false;
    isLoading(true);

    final bool loginResult = await _useCases.login.execute(
      LoginEntity(email: emailController.text, password: passwordController.text),
    );

    if (loginResult) {
      await _saveCredential();

      isAuthenticated(true);

      return true;
    } else {
      await _deleteCredential();

      isLoading(false);

      return false;
    }
  }
}
