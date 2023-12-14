import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongScreen extends StatefulWidget {
  final SongModel song ; 
  const SongScreen({ Key? key ,   required this.song}) : super(key: key);

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.song.title),
      ),

    );
  }
}