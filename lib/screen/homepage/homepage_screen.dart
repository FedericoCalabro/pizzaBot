import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:chatbot/core/audio_player.dart';
import 'package:chatbot/core/dio_provider.dart';
import 'package:chatbot/core/interactions.dart';
import 'package:chatbot/core/speech_to_text.dart';
import 'package:chatbot/core/text_to_speech.dart';
import 'package:chatbot/pizzabot/pizza_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class HomepageScreen extends ConsumerStatefulWidget {
  final double logHeight = 75;
  const HomepageScreen({super.key});

  @override
  ConsumerState<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends ConsumerState<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    final audioPlayer = ref.watch(audioPlayerProvider);
    final tts = ref.watch(ttsProvider);
    final interactionNotifier = ref.watch(interactionsStateProvider.notifier);

    ref.listen(
      pizzaDataNotifierProvider,
      (prev, next) {
        next.maybeWhen(
          loadInProgress: () {
            audioPlayer.open(
              Audio("assets/audios/loading.mp3"),
              autoStart: true,
              showNotification: false,
              loopMode: LoopMode.playlist,
              volume: 0.8,
            );
          },
          loadFailure: (error) {
            audioPlayer.stop();
            interactionNotifier.addInter("E: $error");
          },
          loadSuccess: (answer) {
            audioPlayer.stop();
            interactionNotifier.addInter("A: $answer");
          },
          orElse: () {},
        );
      },
    );

    ref.listen(
      interactionsStateProvider,
      (prev, interactions) {
        final last = interactions.last;
        final type = last[0];
        final readable = last.substring(3, last.length);
        if (type == "Q") {
          ref.read(pizzaDataNotifierProvider.notifier).getAnswer(readable);
        } else {
          tts.speak(readable);
        }
      },
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraint) {
          return Column(
            children: [
              getMic(constraint),
              getStop(constraint),
              getInteractions(constraint)
            ],
          );
        }),
      ),
    );
  }

  Widget getMic(BoxConstraints constraint) {
    final stt = ref.watch(sttProvider);
    return Container(
      color: Colors.green[100],
      width: constraint.maxWidth,
      height: (constraint.maxHeight / 2) - (widget.logHeight / 2),
      child: IconButton(
        onPressed: () {
          if (stt.isNotListening) {
            stt.listen(
              onResult: _onSpeechResult,
              partialResults: false,
            );
          }
        },
        icon: const Icon(Icons.mic),
        iconSize: constraint.maxWidth,
      ),
    );
  }

  Widget getStop(BoxConstraints constraint) {
    return Container(
      color: Colors.red[100],
      width: constraint.maxWidth,
      height: (constraint.maxHeight / 2) - (widget.logHeight / 2),
      child: IconButton(
        onPressed: () {
          globalCancelToken.cancel();
          globalCancelToken = CancelToken();
          ref.read(audioPlayerProvider).stop();
          ref.read(ttsProvider).stop();
          ref.read(sttProvider).cancel();
        },
        icon: const Icon(Icons.stop),
        iconSize: constraint.maxWidth,
      ),
    );
  }

  Widget getInteractions(BoxConstraints constraint) {
    List<String> interactions = ref.watch(interactionsStateProvider);
    return Container(
      color: Colors.lightBlue[100],
      width: constraint.maxWidth,
      height: widget.logHeight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Text(interactions[index]);
          },
          itemCount: interactions.length,
        ),
      ),
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) async {
    final recWords = result.recognizedWords;
    ref.read(interactionsStateProvider.notifier).addInter("Q: $recWords");
  }
}
