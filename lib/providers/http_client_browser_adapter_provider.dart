import 'package:dio/adapter_browser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final httpClientBrowserAdapterProvider = Provider<HttpClientAdapter>((ref){
  return BrowserHttpClientAdapter();
});