import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/constants/routes.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/playlist_screen.dart';
import 'package:music_player/screens/song_screen.dart';
// import 'package:path/path.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
     GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
      getPages: [
        GetPage(name: homeRoute, page:() => const HomeScreen()),
        // GetPage(name: songRoute, page: () => const SongScreen()),
        GetPage(name: playlistRoute, page: ()=> const PlayListScreen())
      ],
    );
  }
}