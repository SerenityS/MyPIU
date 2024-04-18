import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/app/config/app_typeface.dart';
import 'package:piu_util/app/config/routes/route_path.dart';
import 'package:piu_util/presentation/common/widgets/piu_loading.dart';

import '../view_models/login_view_model.dart';

final int drawerIndex = Get.arguments ?? 0;

class LoginPage extends GetView<LoginViewModel> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isAuthenticated.value) {
            Future.microtask(() => Get.offAllNamed("${RoutePath.home}?index=$drawerIndex"));
          }

          if (controller.isLoading.value) {
            return const PIULoading("로그인 중...");
          }
          return _buildLoginForm();
        }),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColor.input,
        ),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("AM.PASS 로그인", style: AppTypeFace().title),
              _buildEmailFormField(),
              _buildPasswordFormField(),
              SizedBox(height: 8.h),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailFormField() {
    return TextFormField(
      controller: controller.emailController,
      decoration: const InputDecoration(hintText: 'Email', hintStyle: TextStyle(color: Colors.grey)),
      validator: (value) => GetUtils.isEmail(value!) ? null : '유효한 이메일을 입력해주세요.',
    );
  }

  Widget _buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      controller: controller.passwordController,
      decoration: const InputDecoration(hintText: 'Password', hintStyle: TextStyle(color: Colors.grey)),
      validator: (value) => value!.isEmpty ? '비밀번호를 입력해주세요.' : null,
      onFieldSubmitted: (value) => _login(),
    );
  }

  Widget _buildLoginButton() {
    return TextButton(
      onPressed: _login,
      child: const Text('Login'),
    );
  }

  Future<void> _login() async {
    await controller.login();
  }
}
