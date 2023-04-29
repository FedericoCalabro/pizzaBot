import 'package:pizzabot/core/custom_exception.dart';
import 'package:pizzabot/core/dio_provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PizzaService {
  final Dio _dio;

  PizzaService(this._dio);

  Future<Map<String, dynamic>> getAnswer(String question) async {
    const String URL = "https://www.pizzagpt.it/api/chat-completion";
    final secret = (await SharedPreferences.getInstance()).getString("secret");

    Map<String, dynamic> data = {
      "question": question,
      "secret": secret,
    };

    Map<String, dynamic> headers = {};

    try {
      final response = await _dio.post(
        URL,
        data: data,
        cancelToken: globalCancelToken,
      );
      return response.data as Map<String, dynamic>;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.connectionError) {
        throw CustomException("Impossibile connettersi al server");
      }
      if (e.type == DioErrorType.cancel) {
        throw CustomException("Richiesta cancellata");
      }
      throw CustomException(e.message ?? "Errore di connessione");
    } catch (e) {
      throw CustomException("Errore generico");
    }
  }

  Future<String> getSecret() async {
    const String URL = "https://www.pizzagpt.it/_nuxt/index.0468b00e.js";

    try {
      final response = await _dio.get(
        URL,
        cancelToken: globalCancelToken,
      );

      return response.data as String;
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
