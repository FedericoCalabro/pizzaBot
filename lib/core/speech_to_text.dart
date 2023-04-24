import 'package:chatbot/core/audio_player.dart';
import 'package:chatbot/core/dio_provider.dart';
import 'package:chatbot/core/text_to_speech.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

final sttProvider = Provider(
  (ref) {
    final stt = SpeechToText();
    stt.initialize(
      onError: (errorNotification) {
        ref.read(ttsProvider).speak(errorNotification.errorMsg);
        ref.read(audioPlayerProvider).stop();
        globalCancelToken.cancel();
        globalCancelToken = CancelToken();
      },
    );
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