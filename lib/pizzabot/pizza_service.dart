import 'dart:developer';

import 'package:chatbot/core/dio_provider.dart';
import 'package:dio/dio.dart';
import '../core/custom_exception.dart';

class PizzaService {
  final Dio _dio;

  PizzaService(this._dio);

  Future<Map<String, dynamic>> getAnswer(String question) async {
    const String URL = "https://www.pizzagpt.it/api/chat-completion";

    Map<String, dynamic> data = {"question": question, "secret": "padrone"};

    Map<String, dynamic> headers = {};

    try {
      final response = await _dio.post(
        URL,
        data: data,
        cancelToken: globalCancelToken,
        options: Options(
          headers: headers,
        ),
      );
      return response.data as Map<String, dynamic>;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.connectionError) {
        throw CustomException("Impossibile connettersi al server");
      }
      throw CustomException(e.message ?? "Errore di connessione");
    } catch (e) {
      throw CustomException("Errore generico");
    }
  }
}
