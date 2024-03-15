import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/config/app_color.dart';
import 'package:piu_util/app/config/app_typeface.dart';

import '../controller/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: CircularProgressIndicator()),
                SizedBox(height: 8.h),
                Text("로그인 중...", style: AppTypeFace().loading),
              ],
            );
          }

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
                    TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(hintText: 'Email', hintStyle: TextStyle(color: Colors.grey)),
                      validator: (value) => GetUtils.isEmail(value!) ? null : '유효한 이메일을 입력해주세요.',
                    ),
                    TextFormField(
                      controller: controller.passwordController,
                      decoration: const InputDecoration(hintText: 'Password', hintStyle: TextStyle(color: Colors.grey)),
                      validator: (value) => value!.isEmpty ? '비밀번호를 입력해주세요.' : null,
                      obscureText: true,
                      onFieldSubmitted: (value) async => await controller.login(),
                    ),
                    SizedBox(height: 8.h),
                    TextButton(
                      onPressed: () async => await controller.login(),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
