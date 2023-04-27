import 'package:chatbot/core/custom_exception.dart';
import 'package:chatbot/pizzabot/pizza_service.dart';
import 'package:fpdart/fpdart.dart';

class PizzaRepository {
  final PizzaService _pizzaService;

  PizzaRepository(this._pizzaService);

  Future<Either<String, CustomException>> getAnswer(String question) async {
    try {
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
}
