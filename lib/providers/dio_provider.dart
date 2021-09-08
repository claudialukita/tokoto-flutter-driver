import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_app/providers/http_client_adapter_provider.dart';
//import 'package:shop_app/providers/http_client_browser_adapter_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final Dio dio = AppDio.getInstance(ref);
  ref.onDispose(() {
    dio.close();
  });
  return dio;
});

class AppDio with DioMixin implements Dio {
  final ProviderReference ref;

  AppDio._(this.ref, [BaseOptions? options]) {
    options = BaseOptions(
      contentType: 'application/json',
      connectTimeout: 30000,
      sendTimeout: 30000,
      receiveTimeout: 30000,
    );

    this.options = options;
    interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          return handler.next(options);
        }, onError: (error, handler) {
      return handler.next(error);
    }));

    if (kDebugMode) {
      // Local Log
      interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    }

    httpClientAdapter = ref.read(httpClientAdapterProvider);
//    httpClientAdapter = ref.read(httpClientBrowserAdapterProvider);
  }

  static Dio getInstance(ProviderReference ref) => AppDio._(ref);
}
