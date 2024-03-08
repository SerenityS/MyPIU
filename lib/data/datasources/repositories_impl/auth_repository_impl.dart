import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:piu_util/app/network/builder/dio_builder.dart';
import 'package:piu_util/domain/entities/login_entity.dart';
import 'package:piu_util/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final Dio _dio = Get.find<DioBuilder>();

  @override
  Future<bool> login(LoginEntity loginEntity) async {
    try {
      // Request Dummy GET to get cookies
      await _dio.get("");

      // Post login request
      var response = await _dio.post("/bbs/login_check.php", data: loginEntity.toJson());

      if (response.data.toString().contains("안녕하세요!")) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await _dio.get("/bbs/logout.php");
    await _dio.interceptors.whereType<CookieManager>().first.cookieJar.deleteAll();
  }
}
