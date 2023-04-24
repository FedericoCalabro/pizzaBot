import 'package:flutter_riverpod/flutter_riverpod.dart';

class Logging {
  static List<String> queue = [];

  static add(String log) => Logging.queue.add(log);
}

class InteractionStateNotifier extends StateNotifier<List<String>> {
  InteractionStateNotifier() : super(List.empty());

  void disposeState() {
    state = List.empty();
  }

  Future<void> addInter(String interaction) async {
    state = [...state, interaction];
  }
}

final interactionsStateProvider =
    StateNotifierProvider<InteractionStateNotifier, List<String>>(
  (ref) {
    return InteractionStateNotifier();
  },
);
