import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_palyer/bloc/bloc_event.dart';

import 'package:music_palyer/bloc/bloc_provider.dart';
import 'package:music_palyer/bloc/bloc_state.dart';
import 'package:music_palyer/cubit/timer_cubit.dart';
import 'package:music_palyer/model/music_model.dart';
import 'package:music_palyer/resource/string_manager.dart';

import 'package:music_palyer/widget/custom_button_widget.dart';
import 'package:music_palyer/widget/image_music_shower.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../resource/styles/color_manager.dart';
import '../resource/styles/style_manager.dart';

// fixed bug when run app
class DetailPage extends StatefulWidget {
  final MusicModel model;
  final MusicModel newModel;

  const DetailPage({Key? key, required this.model, required this.newModel})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late TimerCubit _timerCubit;
  late AnimationController _controller;
  late MusicModel modelState;
  late BlocMusic _blocMusic;

  @override
  void initState() {
    super.initState();
    _timerCubit = BlocProvider.of<TimerCubit>(context);
    _blocMusic = BlocProvider.of<BlocMusic>(context);
    modelState = widget.model;
    maxDuration = widget.newModel.duration;
    musicModelNew = modelState;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  late int maxDuration;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  late MusicModel musicModelNew;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _audioPlayer = _blocMusic.audioPlayer;
    final isNowPlaying = _audioPlayer.state == PlayerState.PLAYING;
    _timerCubit.timer(_audioPlayer.onAudioPositionChanged);
    if (isNowPlaying && modelState == widget.newModel) {
      setState(() {
        _isPlaying = true;
      });
      _controller.forward();
    } else if (isNowPlaying && modelState != widget.newModel) {
      _blocMusic.add(PlayMusic(widget.newModel.id));
      setState(() {
        _isPlaying = true;
      });
      _controller.forward();
      modelState = widget.newModel;
      musicModelNew = modelState;
    } else {
      musicModelNew = widget.newModel;
    }

    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, contrains) {
            return BlocConsumer<BlocMusic, BlocState>(
              listener: ((context, stateBlocMusic) {
                maxDuration = stateBlocMusic.modelState.duration;
              }),
              builder: (c, state) => Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(contrains.maxHeight * 0.010),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButtonWidget(
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColor.styleColor,
                            ),
                          ),
                        ),
                        Text(
                          StringManager.titleOfDetailPage,
                          style: getTitileStyle(fontWeight: FontWeight.w300),
                        ),
                        CustomButtonWidget(
                          isOnPressed: musicModelNew.isFavorite,
                          child: IconButton(
                            onPressed: () {
                              musicModelNew.favoriteMusic();
                              setState(() {});
                            }, // I wll Upadate
                            icon: const Icon(
                              Icons.favorite,
                              color: AppColor.styleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: contrains.maxHeight * 0.35,
                    height: contrains.maxHeight * 0.35,
                    child: ImageMusicShow(
                      imageOfMusic: state.modelState.artworkWidget,
                      size: 230,
                    ),
                  ),
                  SizedBox(
                    height: contrains.maxHeight * 0.040,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: contrains.maxWidth * 0.048),
                    child: Text(
                      state.modelState.title,
                      style: getTitileStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: contrains.maxHeight * 0.01,
                  ),
                  Text(
                    state.modelState.artist,
                    style: getSubTitleStyle(),
                  ),
                  SizedBox(
                    height: contrains.maxHeight * 0.020,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: contrains.maxWidth * 0.05,
                      ),
                      BlocConsumer<TimerCubit, Duration>(
                          listener: (context, state) async {},
                          builder: (context, state) {
                            _duration = state;
                            if (modelState.id != widget.newModel.id) {
                              _duration = Duration.zero;
                            }
                            return Expanded(
                              child: Text(
                                "${_duration.inMinutes > 9 ? _duration.inMinutes : '0' + _duration.inMinutes.toString()}:${_duration.inSeconds % 60 > 9 ? _duration.inSeconds % 60 : '0' + (_duration.inSeconds % 60).toString()}",
                                style: getSubTitleStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            );
                          }),
                      Text(
                          "${state.modelState.duration ~/ 60000 > 9 ? state.modelState.duration ~/ 60000 : '0' + (state.modelState.duration ~/ 60000).toString()}:${(state.modelState.duration ~/ 1000) % 60 > 9 ? (state.modelState.duration ~/ 1000) % 60 : '0' + (state.modelState.duration ~/ 1000 % 60).toString()}",
                          style: getSubTitleStyle(
                              fontSize: 12, fontWeight: FontWeight.w400)),
                      SizedBox(
                        width: contrains.maxWidth * 0.05,
                      ),
                    ],
                  ),
                  BlocConsumer<TimerCubit, Duration>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return _musicSeekTime(context,
                            maxDuration: maxDuration);
                      }),
                  _playButtonsAction(state.modelState.id),
                  _loopButton()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _playButtonsAction(int id) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // previous button
          CustomButtonWidget(
            size: 70,
            child: IconButton(
              onPressed: () async {
                _blocMusic.add(SkipPreviousMusic(id));
                setState(() {
                  _isPlaying = true;
                });
              },
              icon: const Icon(Icons.skip_previous),
            ),
          ),
          // play button
          CustomButtonWidget(
            borderWidth: 0,
            isOnPressed: true,
            size: 80,
            child: BlocListener<BlocMusic, BlocState>(
              bloc: _blocMusic,
              listener: (context, state) {
                if (_blocMusic.audioPlayer.state == PlayerState.STOPPED) {
                  setState(() {
                    _isPlaying = false;
                    _blocMusic.audioPlayer.seek(Duration.zero);
                  });
                  _controller.reverse();
                }
              },
              child: IconButton(
                onPressed: () async {
                  // send event to bloc to play or pause
                  if (_blocMusic.audioPlayer.state == PlayerState.COMPLETED) {
                    _blocMusic.add(PlayMusic(id));

                    setState(() {
                      _isPlaying = true;
                    });
                    _controller.forward();
                  } else if (musicModelNew != modelState) {
                    _blocMusic.add(PlayMusic(id));
                    modelState = musicModelNew;

                    setState(() {
                      _isPlaying = true;
                    });
                    _controller.forward();
                  } else if (_blocMusic.audioPlayer.state ==
                      PlayerState.STOPPED) {
                    _blocMusic.add(PlayMusic(id));
                    setState(() {
                      _isPlaying = true;
                    });
                    _controller.forward();
                  } else {
                    _blocMusic.add(PauseResumeMusic());
                    // this Future for complete progress and supply audio player true value
                    await Future.delayed(
                      const Duration(milliseconds: 300),
                    );
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });

                    if (_isPlaying) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                  }
                },
                icon: AnimatedIcon(
                  progress: _controller,
                  icon: AnimatedIcons.play_pause,
                  color: _isPlaying ? Colors.white : AppColor.styleColor,
                ),
              ),
            ),
          ),
          // next button
          CustomButtonWidget(
            size: 70,
            child: IconButton(
              onPressed: () async {
                _blocMusic.add(SkipNextMusic(id));
              },
              icon: const Icon(Icons.skip_next),
            ),
          ),
        ],
      ),
    );
  }

  Padding _loopButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: IconButton(
          onPressed: () {
            _blocMusic.isOneLoopPlayingSet = !_blocMusic.isOneLoopPlaying;
            setState(() {});
          },
          icon: Icon(
            Icons.loop,
            color: _blocMusic.isOneLoopPlaying
                ? AppColor.darkBlue
                : AppColor.styleColor,
          ),
        ),
      ),
    );
  }

  SfSliderTheme _musicSeekTime(BuildContext context, {int? maxDuration}) {
    return SfSliderTheme(
      data: SfSliderTheme.of(context).copyWith(
        thumbStrokeWidth: 8,
        thumbStrokeColor: AppColor.mainColor,
        activeDividerColor: AppColor.styleColor,
        inactiveDividerColor: AppColor.styleColor.withAlpha(90),
        thumbColor: AppColor.darkBlue,
        thumbRadius: 15,
      ),
      child: SfSlider(
        max: Duration(milliseconds: maxDuration!).inSeconds,
        min: 0,
        value: _duration.inSeconds,
        onChanged: (v) {
          // used for change time of music

          _blocMusic.audioPlayer.seek(Duration(seconds: (v ~/ 1) - 2));
        },
      ),
    );
  }
}
