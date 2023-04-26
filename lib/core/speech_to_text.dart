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
        if (errorNotification.errorMsg != "error_no_match") {
          ref.read(ttsProvider).speak(errorNotification.errorMsg);
          ref.read(audioPlayerProvider).stop();
          globalCancelToken.cancel();
          globalCancelToken = CancelToken();
        }
      },
    );
    return stt;
  },
);
