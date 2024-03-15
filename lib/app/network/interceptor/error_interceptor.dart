import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:piu_util/app/config/routes/route_path.dart';
import 'package:piu_util/presentation/home/controller/home_controller.dart';

class ErrorInterceptor extends QueuedInterceptorsWrapper {
  ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) print('onError ErrorInterceptor ${err.requestOptions.uri}');

    if (err.type == DioExceptionType.badCertificate) {
      Get.offAllNamed(RoutePath.login, arguments: Get.find<HomeController>().drawerIndex);
      Fluttertoast.showToast(msg: "로그인 정보가 만료되어 다시 로그인합니다.");
    } else {
      Fluttertoast.showToast(msg: "네트워크 에러 발생!\n${err.message}");
    }

    handler.next(err);
  }
}
