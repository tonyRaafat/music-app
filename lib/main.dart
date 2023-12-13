import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Songs(),
    ),
  );
}

class Songs extends StatefulWidget {
  const Songs({Key? key}) : super(key: key);

  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  // Main method.
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final player = AudioPlayer();
  // Indicate if application has permission to the library.
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    // (Optinal) Set logging level. By default will be set to 'WARN'.
    //
    // Log will appear on:
    //  * XCode: Debug Console
    //  * VsCode: Debug Console
    //  * Android Studio: Debug and Logcat Console
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);

    // Check and request for permission.
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Player"),
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => player.pause(),
        child: const Icon(Icons.pause_circle),
      ),
      body: Center(
        child: !_hasPermission
            ? noAccessToLibraryWidget()
            : FutureBuilder<List<SongModel>>(
                // Default values:
                future: _audioQuery.querySongs(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
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
                        title: Text(item.data![index].title),
                        subtitle: Text(item.data![index].artist ?? "No Artist"),
                        trailing: const Icon(Icons.arrow_forward_rounded),
                        onTap: () async {
                          print((item.data![index].data).toString());
                          await player.play(DeviceFileSource((item.data![index].data).toString())); // will immediately start playing
                        },
                        // This Widget will query/load image.
                        // You can use/create your own widget/method using [queryArtwork].
                        leading: QueryArtworkWidget(
                          controller: _audioQuery,
                          id: item.data![index].id,
                          type: ArtworkType.AUDIO,
                        ),
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


// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'MP3 File List',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<File> mp3Files = [];

//   @override
//   void initState() {
//     super.initState();
//     _checkPermissionAndFetchFiles();
//   }

//   Future<void> _checkPermissionAndFetchFiles() async {
//     var status = await Permission.audio.request();
//     if (status.isGranted) {
//       _fetchMP3Files();
//     } else {
//       if (await Permission.storage.isPermanentlyDenied) {
//         // Handle if user permanently denied the permission
//         // You may open app settings to enable the permission manually
//         openAppSettings();
//       } else {
//         // Handle the scenario if permissions are denied
//         // You can show a dialog or message to inform the user
//         print('Permission denied');
//       }
//     }
//   }

//   Future<void> _fetchMP3Files() async {
//     Directory? dir = await Directory('/storage/emulated/0/');
//     dir.list();
//     if (dir != null) {
//       try{
//       List<FileSystemEntity> files =
//           dir.listSync(recursive: true, followLinks: false);

//       setState(() {
//         mp3Files = files
//             .where((file) => file.path.endsWith('.mp3'))
//             .toList()
//             .cast<File>();
//       });
//       }catch (e){
//         e.printError();
        
//       }
//     } else {
//       print('Failed to access storage directory');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('MP3 Files'),
//       ),
//       body: ListView.builder(
//         itemCount: mp3Files.length,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(
//             title: Text(mp3Files[index].path.split('/').last),
//             // You can perform actions on the selected MP3 file here
//             onTap: () {
//               // Handle what happens when an MP3 file is tapped
//               // For example, you could play the selected MP3 file
//               print('Selected: ${mp3Files[index].path}');
//             },
//           );
//         },
//       ),
//     );
//   }
// }
