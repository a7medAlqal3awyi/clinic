import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient({Dio? customDio})
      : dio = customDio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.clinic-nutrition.demo/v1',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
      ),
    );
  }
}
