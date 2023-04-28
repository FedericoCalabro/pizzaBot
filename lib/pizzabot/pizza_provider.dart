import 'package:chatbot/core/dio_provider.dart';
import 'package:chatbot/pizzabot/pizza_notifier.dart';
import 'package:chatbot/pizzabot/pizza_repository.dart';
import 'package:chatbot/pizzabot/pizza_service.dart';
import 'package:chatbot/pizzabot/secret_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final secretManagerProvider = Provider(
  (ref) => SecretManager(),
);

final pizzaServiceProvider = Provider(
  (ref) => PizzaService(
    ref.watch(dioProvider),
  ),
);

final pizzaRepositoryProvider = Provider(
  (ref) => PizzaRepository(
    ref.watch(pizzaServiceProvider),
    ref.watch(secretManagerProvider),
  ),
);

final pizzaDataNotifierProvider =
    StateNotifierProvider<PizzaDataNotifier, PizzaDataState>(
  (ref) => PizzaDataNotifier(
    ref.watch(pizzaRepositoryProvider),
  ),
);
