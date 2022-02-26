import 'package:audiotagger/audiotagger.dart';
import 'package:audioplayers/audioplayers.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/bloc_provider.dart';
import '/cubit/timer_cubit.dart';
import '/screen/list_page.dart';
import 'model/music_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'resource/styles/color_manager.dart';

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
    Audiotagger audiotagger = Audiotagger();
    final List<MusicModel> musics = [];
    final songs = await onAudioQuery.querySongs();
    for (var element in songs) {
      if (element.duration != null && element.duration != 0) {
        final artWork = await audiotagger.readArtwork(path: element.data);
        final music = MusicModel(
            artist: element.artist!,
            id: element.id,
            path: element.data,
            title: element.title,
            duration: element.duration!,
            artworkWidget: artWork != null ? Image.memory(artWork) : null);
        musics.add(music);
        await Future.delayed(
            const Duration(microseconds: 10)); // this is for complete ui
      }
    }
    provider.getListOfMusicModel = musics; // provider is bloc music
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
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListPage(
              musics: provider.musics.isEmpty
                  ? ([
                      MusicModel(
                          artworkWidget: null,
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
