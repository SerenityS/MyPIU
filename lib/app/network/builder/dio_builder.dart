import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import 'package:piu_util/app/config/app_const.dart';

import '../interceptor/error_interceptor.dart';
import '../interceptor/redirect_interceptor.dart';
import '../interceptor/session_check_interceptor.dart';

class DioBuilder extends DioMixin implements Dio {
  final CookieJar cookieJar = CookieJar();

  final Duration connectionTimeOutMls = const Duration(milliseconds: 30000);
  final Duration readTimeOutMls = const Duration(milliseconds: 30000);
  final Duration writeTimeOutMls = const Duration(milliseconds: 30000);

  DioBuilder() {
    options = BaseOptions(
      baseUrl: AppConst.baseUrl,
      contentType: Headers.formUrlEncodedContentType,
      connectTimeout: connectionTimeOutMls,
      followRedirects: false,
      receiveTimeout: readTimeOutMls,
      sendTimeout: writeTimeOutMls,
      validateStatus: (status) {
        return status! < 500;
      },
    );

    // Add CookieJar
    interceptors.add(CookieManager(cookieJar));

    // Add interceptor for redirect
    interceptors.add(RedirectInterceptors(this));

    // Add interceptor for error handling
    interceptors.add(ErrorInterceptor());

    // Add interceptor for session check
    interceptors.add(SessionCheckInterceptor());

    // Add interceptor for logging
    // if (kDebugMode) {
    //   interceptors.add(LogInterceptor(
    //     requestBody: true,
    //     responseBody: true,
    //   ));
    // }

    httpClientAdapter = HttpClientAdapter();
  }
}
