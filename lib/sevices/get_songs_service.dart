import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GetSongsService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<bool> checkPermissionAndRequest({bool retry = false}) async {
   return await _audioQuery.checkAndRequest(retryRequest: retry);
  }

  Future<List<SongModel>> getAllSongs() {
    return _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }

  getArtworkWidget(id) {
    return QueryArtworkWidget(
        controller: _audioQuery,
        id: id,
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Container(
          padding:const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color:const Color.fromARGB(213, 83, 83, 83),
            
            borderRadius: BorderRadius.circular(100)
          ),
          child:const Icon(
            Icons.music_note_rounded,
            size: 40.0,
            color: Color.fromARGB(216, 255, 255, 255),
          ),
        ),
        );
  }
}
