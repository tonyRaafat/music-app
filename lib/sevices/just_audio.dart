import 'dart:developer';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioService {
  static final AudioPlayer player = AudioPlayer();
  static String? songPlaying;
  static List<AudioSource> _allSongs = [];
  static ProcessingState processingStateLoading = ProcessingState.loading;
  static ProcessingState processingStateBuffering = ProcessingState.buffering;
  static ProcessingState processingStateComplete = ProcessingState.completed;
  static ProcessingState processingStateReady = ProcessingState.ready;

  static Stream<bool> isPlaying = player.playingStream;
  static Stream<int?> curSong = player.currentIndexStream;
  

  static final playlist = ConcatenatingAudioSource(
    // Start loading next item just before reaching it
    useLazyPreparation: true,
    // Customise the shuffle algorithm
    shuffleOrder: DefaultShuffleOrder(),
    // Specify the playlist items
    children: _allSongs,
  );

  static getAudioSourceList(List allSongs) async {
    List<AudioSource> list = [];

    for (var i = 0; i < allSongs.length; i++) {
      list.add(AudioSource.uri(Uri.file(allSongs[i]!.data, windows: false)));
    }
    log(list.toString());
    _allSongs = list;
    await player.setAudioSource(playlist);
  }

  static Future<void> playSongs(String songToPlay, index , allSongs) async {
    if(songPlaying == songToPlay){
    player.seek( player.position, index: index);
    player.play();
    songPlaying = songToPlay;
    }else{
      player.seek(Duration.zero,index: index);
      player.play();
      songPlaying = songToPlay;
    }
  }
  

  static prevSong() async {
    await player.seekToPrevious();
    return player.previousIndex ?? player.currentIndex;
  }

  static nextSong() async {
    await player.seekToNext();
    return player.nextIndex;
  }

  static pauseAndPlaySong() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }
}
