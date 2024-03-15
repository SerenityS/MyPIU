import 'package:dio/dio.dart';

class SessionCheckInterceptor extends QueuedInterceptor {
  SessionCheckInterceptor();

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 200) {
      if (response.data.toString().contains('alert("로그인 후 이용해주세요.")') ||
          response.data.toString().contains('alert("Please try again after logging in.")')) {
        return handler.reject(
            DioException(
              type: DioExceptionType.badCertificate,
              requestOptions: response.requestOptions,
              response: response,
              error: "Session Expired",
            ),
            true);
      }
      return handler.next(response);
    }
    return handler.next(response);
  }
}
