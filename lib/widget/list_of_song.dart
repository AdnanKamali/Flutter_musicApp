import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_palyer/bloc/bloc_event.dart';
import 'package:music_palyer/bloc/bloc_provider.dart';
import 'package:music_palyer/bloc/bloc_state.dart';
import 'package:music_palyer/model/music_model.dart';
import 'package:music_palyer/screen/detail_page.dart';

import '../resource/styles/color_manager.dart';
import '../resource/styles/style_manager.dart';
import 'custom_button_widget.dart';

class ListOfSong extends StatefulWidget {
  final MusicModel? currentPlayMusic;
  const ListOfSong({Key? key, this.currentPlayMusic}) : super(key: key);

  @override
  State<ListOfSong> createState() => _ListOfSongState();
}

class _ListOfSongState extends State<ListOfSong>
    with SingleTickerProviderStateMixin {
  int _id = 0;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
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
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: bloc.musics.length,
        itemBuilder: (ctx, index) {
          final MusicModel _muicIndex = bloc.musics[index];
          return BlocListener<BlocMusic, BlocState>(
            bloc: bloc,
            listener: (context, state) {
              if (bloc.audioPlayer.state == PlayerState.PLAYING) {
                _id = state.modelState.id;
                _controller.forward();
              } else {
                Future.delayed(const Duration(milliseconds: 400)).then((value) {
                  setState(() {
                    _id = 0;
                  });
                });
                _controller.reverse();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  color: _id == _muicIndex.id
                      ? AppColor.activeColor
                      : AppColor.mainColor,
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c) {
                        bloc.add(
                          SetValue(bloc.musics[index]),
                        );
                        return DetailPage(
                          model: widget.currentPlayMusic!,
                          newModel: _muicIndex,
                        );
                      },
                    ),
                  ).then((value) {
                    setState(() {
                      if (bloc.audioPlayer.state == PlayerState.PLAYING) {
                        _id = widget.currentPlayMusic!.id;
                        _controller.forward();
                      } else {
                        _controller.reverse();
                        _id = 0;
                      }
                    });
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
                          _muicIndex.title.length < 50
                              ? _muicIndex.title
                              : _muicIndex.title.substring(50),
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.start,
                          style: getTitileStyle(fontSize: 16),
                        ),
                        Text(
                          _muicIndex.artist,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.start,
                          style: getSubTitleStyle(),
                        ),
                      ],
                    ),
                    CustomButtonWidget(
                      isOnPressed: _id == _muicIndex.id,
                      child: IconButton(
                          icon: _id == _muicIndex.id
                              ? AnimatedIcon(
                                  progress: _controller,
                                  icon: AnimatedIcons.play_pause,
                                  color: _id == widget.currentPlayMusic!.id
                                      ? Colors.white
                                      : AppColor.styleColor,
                                )
                              : const Icon(Icons.play_arrow),
                          onPressed: () async {
                            // change with event
                            if (bloc.audioPlayer.state != PlayerState.PLAYING) {
                              bloc.add(PlayMusic(_muicIndex.id));

                              _controller.forward();
                              setState(() {
                                _id = _muicIndex.id;
                              });
                            } else if (bloc.audioPlayer.state ==
                                    PlayerState.PLAYING &&
                                widget.currentPlayMusic != _muicIndex) {
                              bloc.add(PlayMusic(_muicIndex.id));
                              _controller.forward();
                              setState(() {
                                _id = _muicIndex.id;
                              });
                            } else {
                              _controller.reverse();
                              bloc.add(PauseResumeMusic());
                              Future.delayed(_controller.duration!)
                                  .then((value) {
                                setState(() {
                                  _id = 0;
                                });
                              });
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
