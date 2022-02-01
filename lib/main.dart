import 'package:audioplayers/audioplayers.dart';
import "package:flutter/material.dart";
import 'package:music_palyer/screen/list_page.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_palyer/model/music_model.dart';

import 'model/music_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  late AudioPlayer audioPlayer;
  @override
  void initState() {
    super.initState();
    artistInfo();
    audioPlayer = AudioPlayer();
  }

  List<MusicModle> musics = [];
  bool isLoadSong = false;
  void artistInfo() async {
    final songs = await audioQuery.getSongs();
    songs.forEach((element) async {
      if (element.id != null &&
          element.title != null &&
          element.duration != null) {
        final music = MusicModle(
          artist: element.artist,
          id: element.id,
          path: element.filePath,
          title: element.title,
          duration: double.parse(element.duration),
        );
        musics.add(music);
        await Future.delayed(
            const Duration(microseconds: 10)); // this is for complete ui
      }
    });
    setState(() {
      isLoadSong = true;
    });
  }

  // int result = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Music Player",
      home: isLoadSong
          ? ListPage(
              musics: musics,
            )
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
