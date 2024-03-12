import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorInterceptor extends QueuedInterceptorsWrapper {
  ErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) print('onError ErrorInterceptor ${err.requestOptions.uri}');
    Fluttertoast.showToast(msg: "네트워크 에러 발생!\n${err.message}");

    handler.next(err);
  }
}
