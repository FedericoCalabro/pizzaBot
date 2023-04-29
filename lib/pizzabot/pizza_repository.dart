import 'package:pizzabot/core/custom_exception.dart';
import 'package:pizzabot/pizzabot/pizza_service.dart';
import 'package:pizzabot/pizzabot/secret_manager.dart';
import 'package:fpdart/fpdart.dart';

class PizzaRepository {
  final PizzaService _pizzaService;
  final SecretManager _secretManager;

  PizzaRepository(
    this._pizzaService,
    this._secretManager,
  );

  Future<Either<String, CustomException>> getAnswer(String question) async {
    try {
      final ehflu = await _secretManager.hoursFromLastUpdate();
      if (ehflu >= 6) {
        final soe = await getSecret();
        soe.fold(
          (l) => _secretManager.set(l),
          (r) => throw CustomException(r.errorMessage),
        );
      }

      final response = await _pizzaService.getAnswer(question);

      if (response['description'] == 'error' ||
          response['answer'] == 'Invalid') {
        throw CustomException("Errore, probabilmente il secret è cambiato");
      }

      return left(response['answer']['content']);
    } on CustomException catch (e) {
      return right(e);
    }
  }

  Future<Either<String, CustomException>> getSecret() async {
    try {
      final response = await _pizzaService.getSecret();
      final secret = _getSecretByRegex(response);
      return left(secret);
    } on CustomException catch (e) {
      return right(e);
    }
  }

  String _getSecretByRegex(String text) {
    var pattern = RegExp(
      "setup.*?secret:(.*?)\\}",
      multiLine: true,
      dotAll: true,
      caseSensitive: true,
      unicode: false,
    );

    var match = pattern.firstMatch(text);
    String? variableStoringSecret = match?.group(1);

    if (match == null || variableStoringSecret == null) {
      throw CustomException("Impossibile parserizzare il secret");
    }

    pattern = RegExp(
      '$variableStoringSecret="(.*?)"',
      multiLine: true,
      dotAll: true,
      caseSensitive: true,
      unicode: false,
    );

    match = pattern.firstMatch(text);
    String? secret = match?.group(1);

    if (match == null || secret == null) {
      throw CustomException("Impossibile parserizzare il secret");
    }

    return secret;
  }
}
