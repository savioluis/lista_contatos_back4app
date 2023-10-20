import 'package:dio/dio.dart';

import 'interceptors/back4app_interceptor.dart';

class HttpProvider {
  final _dio = Dio();

  HttpProvider.back4app() {
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.options.baseUrl = "https://parseapi.back4app.com/";
    _dio.interceptors.add(Back4AppDioInterceptor());
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) {
    return _dio.get(endpoint, queryParameters: queryParameters);
  }

  Future<Response> post(String endpoint, {Object? data}) {
    return _dio.post(endpoint, data: data);
  }

  Future<Response> put(String endpoint, {Map<String, dynamic>? data}) {
    return _dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint, {Map<String, dynamic>? data}) {
    return _dio.delete(endpoint, data: data);
  }
}
