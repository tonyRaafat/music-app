import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GetSongsService {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<String>  songsPath = [];
  

  Future<bool> checkPermissionAndRequest({bool retry = false}) async {
   return await _audioQuery.checkAndRequest(retryRequest: retry);
  }

   getAllPath() async {
    songsPath =  await _audioQuery.queryAllPath();
  }

  Future<List<SongModel>> getAllSongs() {
    
    return _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }

  getArtworkWidget(id,{ double nullIconSize = 40, double artHeight = 50, double artWidth = 50  }) {
    return QueryArtworkWidget(
        controller: _audioQuery,
        id: id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Container(
          padding:const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color:const Color.fromARGB(213, 83, 83, 83),
            
            borderRadius: BorderRadius.circular(50)
          ),
          child: Icon(
            Icons.music_note_rounded,
            size: nullIconSize ,
            color: Color.fromARGB(216, 255, 255, 255),
          ),
        ),
        artworkHeight: artHeight ,
        artworkWidth: artWidth,
        artworkBorder: BorderRadius.circular(50),
        artworkQuality: FilterQuality.high,
        size:800,
        );
  }
}
