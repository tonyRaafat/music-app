import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/sevices/get_songs_service.dart';
import 'package:music_player/sevices/just_audio.dart';
import 'package:music_player/widgets/seek_bar.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
// import 'package:on_audio_query/on_audio_query.dart';

class SongScreen extends StatefulWidget {
  var index;
  final allSongs;
  SongScreen({Key? key, required this.index, required this.allSongs})
      : super(key: key);

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  final GetSongsService _getSongs = GetSongsService();
  final double sizeOfButtons = 80.0;

  Stream<SeekBarData> get _seekbarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          AudioService.player.positionStream,
          AudioService.player.durationStream, (
        Duration position,
        Duration? duration,
      ) {
        return SeekBarData(position, duration ?? Duration.zero);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(128, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(2, 20, 2, 60),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getSongs.getArtworkWidget(widget.allSongs![widget.index].id,
                  artHeight: 250, artWidth: 250, nullIconSize: 250),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 30),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(widget.allSongs![widget.index].title,
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ),
              
              StreamBuilder<SeekBarData>(
                  stream: _seekbarDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      position: positionData?.position ?? Duration.zero,
                      duration: positionData?.duration ?? Duration.zero,
                      onChangeEnd: AudioService.player.seek,
                    );
                  }),
              PlayerController(),
            ]),
      ),
    );
  }

  Widget PlayerController() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              AudioService.prevSong();
              widget.index = widget.index - 1;
              setState(() {});
            },
            icon: const Icon(
              Icons.skip_previous_rounded,
              size: 67,
            )),
        StreamBuilder(
            stream: AudioService.player.playerStateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final playerState = snapshot.data;
                final proccesingState = playerState!.processingState;

                if (proccesingState == AudioService.processingStateLoading ||
                    proccesingState == AudioService.processingStateBuffering) {
                  return Container(
                    width: 64.0,
                    height: 64.0,
                    margin: const EdgeInsets.all(10),
                    child: const CircularProgressIndicator(),
                  );
                } else if (!AudioService.isPlaying) {
                  return IconButton(
                    onPressed: () {
                      AudioService.pauseAndPlaySong();   
                    },
                    icon: const Icon(
                      Icons.play_circle_filled_rounded,
                      size: 70,
                    ),
                  );
                } else if (proccesingState != ProcessingState.completed) {
                  return IconButton(
                    onPressed: () => AudioService.pauseAndPlaySong(),
                    icon: const Icon(
                      Icons.pause_circle_filled_rounded,
                      size: 70,
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              } else {
                return const CircularProgressIndicator();
              }
            }),
        IconButton(
            onPressed: () {
              AudioService.nextSong();
              widget.index = widget.index + 1;
              setState(() {});
            },
            icon: const Icon(
              Icons.skip_next_rounded,
              size: 67,
            )),
      ],
    );
  }
}
