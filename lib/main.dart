import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_palyer/bloc/bloc_provider.dart';
import 'package:music_palyer/screen/list_page.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_palyer/bloc/music_model.dart';

import 'bloc/music_model.dart';

void main() => runApp(BlocProvider<BlocMusic>(
      create: (context) => BlocMusic(),
      child: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  late AudioPlayer audioPlayer;
  late BlocMusic provider;
  @override
  void initState() {
    super.initState();
    provider = BlocProvider.of<BlocMusic>(context);
    artistInfo();
    audioPlayer = AudioPlayer();
  }

  List<MusicModleState> musics = [];
  bool isLoadSong = false;
  void artistInfo() async {
    final songs = await audioQuery.getSongs();
    songs.forEach((element) async {
      if (element.id != null &&
          element.title != null &&
          element.duration != null) {
        final music = MusicModleState(
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
    provider.getListOfMusicModleState(musics);
  }

  // int result = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Music Player",
      home: isLoadSong
          ? ListPage(
              musics: musics.isEmpty
                  ? ([
                      MusicModleState(
                          artist: "Not Found",
                          id: "Not Found",
                          duration: 0,
                          path: "",
                          title: "Not Found"),
                    ])
                  : musics,
            )
          : const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
