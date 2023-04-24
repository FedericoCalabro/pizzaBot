import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:text_to_speech/text_to_speech.dart';

final ttsProvider = Provider(
  (ref) {
    final tts = TextToSpeech();
    return tts;
  },
);
