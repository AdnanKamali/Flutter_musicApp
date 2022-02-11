import 'package:audioplayers/audioplayers.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_palyer/bloc/bloc_provider.dart';
import 'package:music_palyer/cubit/timer_cubit.dart';
import 'package:music_palyer/my_colors.dart';
import 'package:music_palyer/screen/list_page.dart';

import 'package:music_palyer/bloc/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'bloc/music_model.dart';

void main() => runApp(MultiBlocProvider(
      providers: [
        BlocProvider<TimerCubit>(create: (ctx) => TimerCubit()),
        BlocProvider<BlocMusic>(create: (ctx) => BlocMusic()),
      ],
      child: const MyApp(),
    ));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AudioPlayer audioPlayer;
  late BlocMusic provider;
  late OnAudioQuery onAudioQuery;
  @override
  void initState() {
    super.initState();
    onAudioQuery = OnAudioQuery();
    artistInfo();
    provider = BlocProvider.of<BlocMusic>(context);
    audioPlayer = AudioPlayer();
  }

  void artistInfo() async {
    final List<MusicModleState> musics = [];
    final songs = await onAudioQuery.querySongs();
    for (var element in songs) {
      if (element.duration != null) {
        final music = MusicModleState(
          artist: element.artist!,
          id: element.id,
          path: element.data,
          title: element.title,
          duration: element.duration!,
        );
        musics.add(music);
        await Future.delayed(
            const Duration(microseconds: 10)); // this is for complete ui
      }
    }
    provider.getListOfMusicModleState = musics;
    setState(() {
      isLoading = false;
    });
  }

  bool isLoading = true;

  // int result = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Music Player",
      home: isLoading
          ? const Scaffold(
              backgroundColor: AppColor.mainColor,
              body: Center(child: CircularProgressIndicator()))
          : ListPage(
              musics: provider.musics.isEmpty
                  ? ([
                      MusicModleState(
                          artist: "Not Found",
                          id: 0,
                          duration: 0,
                          path: "",
                          title: "Not Found"),
                    ])
                  : provider.musics,
            ),
    );
  }
}
