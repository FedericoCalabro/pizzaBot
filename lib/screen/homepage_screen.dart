import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:chatbot/core/audio_player.dart';
import 'package:chatbot/core/dio_provider.dart';
import 'package:chatbot/core/interactions.dart';
import 'package:chatbot/core/speech_to_text.dart';
import 'package:chatbot/core/text_to_speech.dart';
import 'package:chatbot/pizzabot/pizza_provider.dart';
import 'package:chatbot/screen/secret_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class HomepageScreen extends ConsumerStatefulWidget {
  final double logHeight = 75;
  int consecutiveStopTaps = 0;
  HomepageScreen({super.key});

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
              volume: 0.75,
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
        child: LayoutBuilder(builder: (layoutContext, constraint) {
          return Column(
            children: [
              getMic(constraint, context),
              getStop(constraint, context),
              getInteractions(constraint)
            ],
          );
        }),
      ),
    );
  }

  Widget getMic(BoxConstraints constraint, BuildContext context) {
    final stt = ref.watch(sttProvider);
    final dataProvider = ref.watch(pizzaDataNotifierProvider);
    final interactionNotifier = ref.watch(interactionsStateProvider.notifier);
    final interactions = ref.watch(interactionsStateProvider);
    return InkWell(
      child: Container(
        color: Colors.green[100],
        width: constraint.maxWidth,
        height: (constraint.maxHeight / 2) - (widget.logHeight / 2),
        child: Icon(
          Icons.mic,
          size: constraint.maxWidth,
        ),
      ),
      onTap: () async {
        widget.consecutiveStopTaps = 0;
        if (stt.isAvailable) {
          if (stt.isNotListening) {
            dataProvider.maybeWhen(
              loadInProgress: () async {
                stopEverything();
                await Future.delayed(const Duration(
                  seconds: 2,
                  milliseconds: 500,
                ));
                stt.listen(
                  onResult: _onSpeechResult,
                  partialResults: false,
                );
              },
              orElse: () async {
                stt.listen(
                  onResult: _onSpeechResult,
                  partialResults: false,
                );
              },
            );
          }
        } else {
          interactionNotifier.addInter("E: Errore con l'SST");
        }
      },
    );
  }

  Widget getStop(BoxConstraints constraint, BuildContext context) {
    return InkWell(
      child: Container(
        color: Colors.red[100],
        width: constraint.maxWidth,
        height: (constraint.maxHeight / 2) - (widget.logHeight / 2),
        child: Icon(
          Icons.stop,
          size: constraint.maxWidth,
        ),
      ),
      onTap: () {
        widget.consecutiveStopTaps += 1;
        if (widget.consecutiveStopTaps >= 20) {
          widget.consecutiveStopTaps = 0;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SecretScreen(),
            ),
          );
          return;
        }
        stopEverything();
      },
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

  void stopEverything() {
    globalCancelToken.cancel();
    globalCancelToken = CancelToken();
    ref.read(audioPlayerProvider).stop();
    ref.read(ttsProvider).stop();
    ref.read(sttProvider).cancel();
  }
}
