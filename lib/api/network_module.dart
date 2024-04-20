import 'package:dio/dio.dart';
import 'package:speakupp/api/request_interceptor.dart';
import 'package:speakupp/common/app_resourses.dart';

class NetworkModule {
  final Dio _dio = Dio();
  final String _baseUrl = AppResourses.appStrings.getBaseUrl();
  final RequestInterceptor requestInterceptor;

  NetworkModule({required this.requestInterceptor});

  BaseOptions _dioOptions() {
    BaseOptions opts = BaseOptions();
    opts.baseUrl = _baseUrl;
    opts.connectTimeout = const Duration(milliseconds: 60000);
    opts.receiveTimeout = const Duration(milliseconds: 60000);
    opts.sendTimeout = const Duration(milliseconds: 60000);
    return opts;
  }

  Dio provideDio() {
    _dio.options = _dioOptions();
    _dio.interceptors.add(requestInterceptor);
    return _dio;
  }
}
