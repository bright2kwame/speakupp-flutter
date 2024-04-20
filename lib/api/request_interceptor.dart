import 'package:dio/dio.dart';
import 'package:speakupp/persistence/shared_preference_module.dart';

class RequestInterceptor extends Interceptor {
  final SharedPreferenceModule pref;

  RequestInterceptor({required this.pref});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String userData = pref.getUserData();
    if (userData.isNotEmpty) {
      options.headers["Authorization"] = "Token $userData";
    } else {
      options.headers["Authorization"] =
          "Token 729cb6d0db88b80a270dac27bff0f598d3b53d18";
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("=== ${err.response} ===");
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
