import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalCancelToken = CancelToken();

final dioProvider = Provider(
  (ref) => Dio(
    BaseOptions(
      // connectTimeout: const Duration(seconds: 2), TODO
      responseType: ResponseType.json,
      followRedirects: false,
      headers: {
        'Accept': "application/json",
        'Content-Type': "application/json",
      },
    ),
  ),
);
