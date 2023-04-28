import 'package:chatbot/core/audio_player.dart';
import 'package:chatbot/core/speech_to_text.dart';
import 'package:chatbot/core/text_to_speech.dart';
import 'package:chatbot/pizzabot/pizza_provider.dart';
import 'package:chatbot/screen/homepage_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Bot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomepageScreen(),
    );
  }
}
