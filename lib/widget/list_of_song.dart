import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_palyer/bloc/bloc_event.dart';
import 'package:music_palyer/bloc/bloc_provider.dart';
import 'package:music_palyer/screen/detail_page.dart';
import 'package:music_palyer/screen/list_page.dart';
import 'package:music_palyer/styles/style_manager.dart';
import 'custom_button_widget.dart';
import '../styles/color_manager.dart';

class ListOfSong extends StatefulWidget {
  final String id;
  const ListOfSong({
    Key? key,
    required this.widget,
    required this.id,
  }) : super(key: key);

  final ListPage widget;

  @override
  State<ListOfSong> createState() => _ListOfSongState();
}

class _ListOfSongState extends State<ListOfSong>
    with SingleTickerProviderStateMixin {
  int _id = 0;
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(playerId: "Adnan");
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    if (bloc.audioPlayer.state == PlayerState.PLAYING) {
      _id = bloc.currentPlay.id;
      _controller.forward();
    } else {
      _id = 0;
    }
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: bloc.musics.length,
        itemBuilder: (ctx, index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
                color: _id == bloc.musics[index].id
                    ? AppColor.activeColor
                    : AppColor.mainColor,
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () {
                if (_audioPlayer.state == PlayerState.PLAYING) {
                  bloc.audioPlayerSet = _audioPlayer;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (c) {
                      bloc.add(NewMusicPlay(bloc.musics[index].id));
                      return DetailPage(
                        modle: bloc.musics[index],
                      );
                    },
                  ),
                ).then((value) {
                  setState(() {}); // update widgets
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bloc.musics[index].title.length < 50
                            ? bloc.musics[index].title
                            : bloc.musics[index].title.substring(50),
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.start,
                        style: getTitileStyle(fontSize: 16),
                      ),
                      Text(
                        bloc.musics[index].artist,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.start,
                        style: getSubTitleStyle(),
                      ),
                    ],
                  ),
                  CustomButtonWidget(
                    isOnPressed: _id == bloc.musics[index].id,
                    child: IconButton(
                      icon: _id == bloc.musics[index].id
                          ? AnimatedIcon(
                              progress: _controller,
                              icon: AnimatedIcons.play_pause,
                              color: _id == bloc.musics[index].id
                                  ? Colors.white
                                  : AppColor.styleColor,
                            )
                          : const Icon(Icons.play_arrow),
                      onPressed: () async {
                        if (bloc.currentPlay != bloc.musics[index]) {
                          setState(() {
                            bloc.nowPlayingSet = bloc.musics[index];
                          });
                          await _audioPlayer.play(bloc.musics[index].path);
                          _controller.forward();
                          setState(() {
                            _id = bloc.currentPlay.id;
                          });
                        } else if (bloc.currentPlay == bloc.musics[index] &&
                            _audioPlayer.state == PlayerState.PLAYING) {
                          await _audioPlayer.pause();
                          Future.delayed(_controller.duration!).then(
                            (value) {
                              setState(() {
                                _id = 0;
                              });
                            },
                          ); // Future for hamahang animation
                          _controller.reverse();
                        } else if (bloc.currentPlay == bloc.musics[index] &&
                            _audioPlayer.state != PlayerState.PLAYING) {
                          await _audioPlayer.play(bloc.musics[index].path);
                          setState(() {
                            _id = bloc.currentPlay.id;
                          });
                          _controller.forward();
                        }
                        bloc.audioPlayerSet = _audioPlayer;
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
