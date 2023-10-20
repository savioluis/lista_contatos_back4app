import 'package:dio/dio.dart';

class Back4AppDioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["X-Parse-Application-Id"] =
        "rBmvRA24Sm2t8mDtI0ELOHeCnujImceWA2ShHIar";
    options.headers["X-Parse-REST-API-Key"] =
        "9pF0zq3doOc9EY9QEzyaB7eBK6myhXlPv0vLgRnG";

    print('REQUEST[${options.method}] => PATH: ${options.path}');
    print('HEADERS ${options.headers}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}

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
