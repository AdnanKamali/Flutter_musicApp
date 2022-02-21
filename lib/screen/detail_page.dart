import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_palyer/bloc/bloc_event.dart';

import 'package:music_palyer/bloc/bloc_provider.dart';
import 'package:music_palyer/cubit/timer_cubit.dart';
import 'package:music_palyer/bloc/music_model.dart';
import 'package:music_palyer/styles/color_manager.dart';
import 'package:music_palyer/styles/style_manager.dart';

import 'package:music_palyer/widget/custom_button_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DetailPage extends StatefulWidget {
  final MusicModel model;
  final MusicModel newmodel;

  const DetailPage({Key? key, required this.model, required this.newmodel})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late TimerCubit _timerCubit;
  late AudioPlayer _audioPlayer;
  late AnimationController _controller;
  late MusicModel modelState;
  late BlocMusic _blocMusic;

  @override
  void initState() {
    super.initState();
    _timerCubit = BlocProvider.of<TimerCubit>(context);
    _blocMusic = BlocProvider.of<BlocMusic>(context);
    _audioPlayer = _blocMusic.audioPlayer;
    modelState = widget.model;
    musicModelNew = modelState;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

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
    _timerCubit.timer(_audioPlayer.onAudioPositionChanged);
    final isNowPlaying = _audioPlayer.state == PlayerState.PLAYING;
    if (isNowPlaying && modelState == widget.newmodel) {
      setState(() {
        _isPlaying = true;
      });
      _controller.forward();
    } else if (isNowPlaying && modelState != widget.newmodel) {
      _blocMusic.add(PlayMusic(widget.newmodel.id));
      setState(() {
        _isPlaying = true;
      });
      _controller.forward();
      modelState = widget.newmodel;
      musicModelNew = modelState;
    } else {
      musicModelNew = widget.newmodel;
    }
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: SafeArea(child: LayoutBuilder(builder: (context, contrains) {
        return Column(
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
                  const Text(
                    "PLAYING NOW",
                    style: TextStyle(color: AppColor.styleColor),
                  ),
                  const CustomButtonWidget(
                    child: IconButton(
                      onPressed: null, // I wll Upadate
                      icon: Icon(
                        Icons.menu,
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
              width: 290,
              height: 290,
              child: Hero(tag: "ImageTag", child: musicModelNew.artworkWidget!),
            ),
            SizedBox(
              height: contrains.maxHeight * 0.075,
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: contrains.maxWidth * 0.048),
                  child: FittedBox(
                    child: Text(
                      musicModelNew.title,
                      style: TextStyle(
                          color: AppColor.styleColor,
                          fontSize: MediaQuery.of(context).size.width < 420
                              ? 24
                              : 29),
                    ),
                  ),
                ),
                SizedBox(
                  height: contrains.maxHeight * 0.015,
                ),
                FittedBox(
                  child: Text(
                    musicModelNew.artist,
                    style: TextStyle(
                        color: AppColor.styleColor.withOpacity(0.4),
                        fontSize:
                            MediaQuery.of(context).size.width < 420 ? 19 : 23),
                  ),
                ),
                SizedBox(
                  height: contrains.maxHeight * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    BlocConsumer<TimerCubit, Duration>(
                        listener: (context, state) async {
                      // if end play next or oneloop play again
                    }, builder: (context, state) {
                      _duration = state;
                      if (modelState.id != widget.newmodel.id) {
                        _duration = Duration.zero;
                      }

                      return Expanded(
                        child: Text(
                            "${_duration.inMinutes > 9 ? _duration.inMinutes : '0' + _duration.inMinutes.toString()}:${_duration.inSeconds % 60 > 9 ? _duration.inSeconds % 60 : '0' + (_duration.inSeconds % 60).toString()}",
                            style: getSubTitleStyle(
                                fontSize: 16, fontWeight: FontWeight.w400)),
                      );
                    }),
                    Text(
                        "${musicModelNew.duration ~/ 60000 > 9 ? musicModelNew.duration ~/ 60000 : '0' + (musicModelNew.duration ~/ 60000).toString()}:${(musicModelNew.duration ~/ 1000) % 60 > 9 ? (musicModelNew.duration ~/ 1000) % 60 : '0' + (musicModelNew.duration ~/ 1000 % 60).toString()}",
                        style: getSubTitleStyle(
                            fontSize: 16, fontWeight: FontWeight.w400)),
                    const SizedBox(
                      width: 25,
                    ),
                  ],
                ),
                BlocConsumer<TimerCubit, Duration>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return SfSliderTheme(
                          data: SfSliderTheme.of(context).copyWith(
                            thumbStrokeWidth: 8,
                            thumbStrokeColor: AppColor.mainColor,
                            activeDividerColor: AppColor.styleColor,
                            inactiveDividerColor:
                                AppColor.styleColor.withAlpha(90),
                            thumbColor: AppColor.darkBlue,
                            thumbRadius: 15,
                          ),
                          child: SfSlider(
                            max: modelState.duration ~/ 1000 == 0
                                ? musicModelNew.duration ~/ 1000
                                : modelState.duration ~/ 1000,
                            min: 0,
                            value: _duration.inSeconds,
                            onChanged: (v) {
                              // use for change time of music

                              _audioPlayer
                                  .seek(Duration(seconds: (v ~/ 1) - 2));
                            },
                          ));
                    }),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButtonWidget(
                          size: MediaQuery.of(context).size.height < 680
                              ? 70
                              : 75,
                          child: IconButton(
                            onPressed: () async {
                              // Skip Previous Button...
                              // send event to bloc to previous
                              _blocMusic
                                  .add(SkipPreviousMusic(musicModelNew.id));
                              setState(() {
                                _isPlaying = true;
                              });
                            },
                            icon: const Icon(Icons.skip_previous),
                          ),
                        ),
                        CustomButtonWidget(
                          // Play button...
                          borderWidth: 0,
                          isOnPressed: true,
                          size: MediaQuery.of(context).size.height < 680
                              ? 75
                              : 80,
                          child: IconButton(
                            onPressed: () async {
                              // send event to bloc to play or pause
                              if (_blocMusic.audioPlayer.state ==
                                  PlayerState.COMPLETED) {
                                _blocMusic.add(PlayMusic(musicModelNew.id));
                                setState(() {
                                  _isPlaying = true;
                                });
                                _controller.forward();
                              } else if (musicModelNew != modelState) {
                                _blocMusic.add(PlayMusic(musicModelNew.id));
                                modelState = musicModelNew;
                                setState(() {
                                  _isPlaying = true;
                                });
                                _controller.forward();
                              } else {
                                _blocMusic.add(PauseResumeMusic());
                                await Future.delayed(const Duration(
                                    milliseconds:
                                        300)); // this Future for complete progress and supply audio player true value
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
                              color: _isPlaying
                                  ? Colors.white
                                  : AppColor.styleColor,
                            ),
                          ),
                        ),
                        CustomButtonWidget(
                          size: MediaQuery.of(context).size.height < 680
                              ? 70
                              : 75,
                          child: IconButton(
                            onPressed: () async {
                              // Skip Next Button...
                              // use bloc add event to go next
                              _blocMusic
                                  .add(SkipPreviousMusic(musicModelNew.id));
                            },
                            icon: const Icon(Icons.skip_next),
                          ),
                        ),
                      ],
                    )),
              ],
            )
          ],
        );
      })),
    );
  }
}
