import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioPlayerProvider = Provider(
  (ref) {
    AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();
    return player;
  },
);
