import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

final sttProvider = Provider(
  (ref) {
    final stt = SpeechToText();
    stt.initialize();
    return stt;
  },
);


  // Future<void> listen() async {
  //   state = const SttState.listening();
  //   await stt.listen(
  //     onResult: onSpeechResult,
  //     partialResults: false,
  //   );
  // }

  // Future<void> stopListening() async {
  //   await stt.stop();
  //   state = const SttState.waiting();
  // }

  // Future<void> cancelPendingRequests() async {
  //   globalCancelToken.cancel();
  //   state = const SttState.waiting();
  // }

  // Future<void> onSpeechResult(SpeechRecognitionResult result) async {
  //   state = const SttState.waiting();
  //   final recWords = result.recognizedWords;
  //   if (recWords.isNotEmpty) {
  //     interactionStateNotifier.addInter("Q: ${recWords}");
  //   }
  // }
// }