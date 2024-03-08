import 'package:dio/dio.dart';

class RedirectInterceptors extends Interceptor {
  final Dio _dio;
  RedirectInterceptors(this._dio);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 302) {
      // 리디렉션 URL 추출
      var redirectUrl = response.headers.value('location');

      if (redirectUrl != null) {
        // 새로운 URL로 요청 수행
        var followUpResponse = await _dio.get(redirectUrl);
        handler.resolve(followUpResponse);
      } else {
        super.onResponse(response, handler);
      }
    } else {
      super.onResponse(response, handler);
    }
  }
}
