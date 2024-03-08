import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piu_util/domain/entities/login_entity.dart';
import 'package:piu_util/domain/usecases/auth_usecases.dart';

class LoginController extends GetxController {
  final AuthUseCases _useCases = Get.find<AuthUseCases>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    final result = await _useCases.login.execute(
      LoginEntity(email: emailController.text, password: passwordController.text),
    );

    if (result) {
      Get.snackbar('Success', 'Login Success');
    } else {
      Get.snackbar('Error', 'Login Failed');
    }
  }

  Future<void> logout() async {
    await _useCases.logout.execute();
  }
}
