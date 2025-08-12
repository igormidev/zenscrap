import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  // dio.interceptors.add(
  //   AwesomeDioInterceptor(
  //     logger: debugPrint,
  //   ),
  // );
  return dio;
});
