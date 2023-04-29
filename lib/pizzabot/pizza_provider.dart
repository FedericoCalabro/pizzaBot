import 'package:pizzabot/core/dio_provider.dart';
import 'package:pizzabot/pizzabot/pizza_notifier.dart';
import 'package:pizzabot/pizzabot/pizza_repository.dart';
import 'package:pizzabot/pizzabot/pizza_service.dart';
import 'package:pizzabot/pizzabot/secret_manager.dart';
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
