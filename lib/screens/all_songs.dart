import 'package:flutter/material.dart';
import 'package:music_player/sevices/get_songs_service.dart';
import 'package:music_player/sevices/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AllSongs extends StatefulWidget {
  const AllSongs({Key? key}) : super(key: key);

  @override
  _AllSongsState createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  // Main method.
  // final OnAudioQuery _audioQuery = OnAudioQuery();
  final GetSongsService _audioServics = GetSongsService();
  final player = AudioService();
  // Indicate if application has permission to the library.
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();

    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioServics.checkPermissionAndRequest();

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await player.pauseSong(),
        child: const Icon(Icons.pause_circle),
      ),
      body: Center(
        child: !_hasPermission
            ? noAccessToLibraryWidget()
            : FutureBuilder<List<SongModel>>(
                // Default values:

                future: _audioServics.getAllSongs(),
                builder: (context, item) {
                  // Display error, if any.
                  if (item.hasError) {
                    return Text(item.error.toString());
                  }

                  // Waiting content.
                  if (item.data == null) {
                    return const CircularProgressIndicator();
                  }

                  // 'Library' is empty.
                  if (item.data!.isEmpty) return const Text("Nothing found!");

                  // You can use [item.data!] direct or you can create a:
                  // List<SongModel> songs = item.data!;
                  return ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        // textColor: Colors.white,
                        title: Text(item.data![index].title),
                        subtitle: Text(item.data![index].artist ?? "No Artist"),
                        // trailing: const Icon(Icons.arrow_forward_rounded),
                        onTap: () => player
                            .playSong((item.data![index].data).toString()),
                        // This Widget will query/load image.
                        // You can use/create your own widget/method using [queryArtwork].
                        leading:
                            _audioServics.getArtworkWidget(item.data![index].id),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}
