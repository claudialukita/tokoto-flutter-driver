import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final httpClientAdapterProvider = Provider<HttpClientAdapter>((ref){
  return DefaultHttpClientAdapter();
});