import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  String? songPlaying;

   playSong(String songToPlay) async {
    if (songPlaying == songToPlay) {
      await _player.play();
    } else {
      await _player.setAudioSource(AudioSource.uri(Uri.file(songToPlay, windows: false)));
      await _player.play();
      songPlaying = songToPlay;
    }
  }

   pauseSong() async{
    await _player.pause();
  }
}
