import 'dart:developer';

import 'package:chatbot/core/interactions.dart';
import 'package:chatbot/pizzabot/pizza_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';

class PizzaScreen extends ConsumerStatefulWidget {
  PizzaScreen({super.key});

  @override
  ConsumerState<PizzaScreen> createState() => _PizzaScreenState();
}

class _PizzaScreenState extends ConsumerState<PizzaScreen> {
  SpeechToText _speechToText = SpeechToText();
  TextToSpeech tts = TextToSpeech();
  bool _speechEnabled = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(
      pizzaDataNotifierProvider,
      (previous, next) {
        next.maybeWhen(
          loadSuccess: (answer) async {
            Logging.add(answer);
            setState(() {});
            await tts.speak(answer);
          },
          loadFailure: (errore) async {
            Logging.add(errore);
            setState(() {});
            tts.speak(errore);
          },
          orElse: () => {},
        );
      },
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraint) {
          return Column(
            children: [
              IconButton(
                  icon: const Icon(Icons.mic),
                  iconSize: constraint.biggest.width,
                  onPressed: _speechToText.isNotListening
                      ? _startListening
                      : _stopListening),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(Logging.queue[index]),
                    );
                  },
                  itemCount: Logging.queue.length,
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    tts.stop();
    await _speechToText.listen(
      onResult: _onSpeechResult,
      partialResults: false,
    );
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    Logging.add(result.recognizedWords);
    setState(() {});
    final test = await ref
        .read(pizzaDataNotifierProvider.notifier)
        .getAnswer(result.recognizedWords);
  }
}
