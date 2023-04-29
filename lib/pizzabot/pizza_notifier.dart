import 'package:pizzabot/pizzabot/pizza_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pizza_notifier.freezed.dart';

@freezed
class PizzaDataState with _$PizzaDataState {
  const factory PizzaDataState.initial() = _Initial;
  const factory PizzaDataState.loadInProgress() = _LoadInProgress;
  const factory PizzaDataState.loadFailure(String error) = _LoadFailure;
  const factory PizzaDataState.loadSuccess(String message) = _LoadSuccess;
}

class PizzaDataNotifier extends StateNotifier<PizzaDataState> {
  final PizzaRepository _pizzaRepository;

  PizzaDataNotifier(this._pizzaRepository)
      : super(const PizzaDataState.initial());

  void disposeState() {
    state = const PizzaDataState.initial();
  }

  Future<void> getAnswer(String question) async {
    state = const PizzaDataState.loadInProgress();

    final successOrFailure = await _pizzaRepository.getAnswer(question);

    state = successOrFailure.fold(
      (l) => PizzaDataState.loadSuccess(l),
      (r) => PizzaDataState.loadFailure(r.errorMessage),
    );
  }
}
