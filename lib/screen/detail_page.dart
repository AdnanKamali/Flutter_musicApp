import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:music_palyer/bloc/bloc_provider.dart';
import 'package:music_palyer/cubit/timer_cubit.dart';
import 'package:music_palyer/bloc/music_model.dart';
import 'package:music_palyer/my_colors.dart';

import 'package:music_palyer/widget/custom_button_widget.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DetailPage extends StatefulWidget {
  final MusicModleState modle;
  const DetailPage({Key? key, required this.modle}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late TimerCubit _timerCubit;
  late AudioPlayer _audioPlayer;
  late AnimationController _controller;
  late MusicModleState modleState;
  late BlocMusic _blocMusic;

  @override
  void initState() {
    super.initState();
    _timerCubit = BlocProvider.of<TimerCubit>(context);
    _blocMusic = BlocProvider.of<BlocMusic>(context);
    modleState = widget.modle;
    if (_blocMusic.audioPlayer.playerId == "Adnan") {
      _audioPlayer = _blocMusic.audioPlayer;
    } else {
      _audioPlayer = AudioPlayer(playerId: "Adnan");
      _blocMusic.audioPlayerSet = _audioPlayer;
    }
    // _blocMusic.nowPlayingSet = modleState;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  Duration _duration = Duration.zero;
  bool _isPlaying = false;

  @override
  void dispose() {
    super.dispose();
    _blocMusic.audioPlayerSet = _audioPlayer;
    _blocMusic.nowPlayingSet = _blocMusic.findById(modleState.id);

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _timerCubit.timer(_audioPlayer.onAudioPositionChanged);
    if (_blocMusic.currentPlay == modleState &&
        _blocMusic.audioPlayer.state == PlayerState.PLAYING) {
      setState(() {
        _isPlaying = true;
      });
      _controller.forward();
    } else if (_blocMusic.currentPlay != modleState &&
        _blocMusic.audioPlayer.state == PlayerState.PLAYING) {
      _audioPlayer.play(modleState.path);
      _blocMusic.nowPlayingSet = modleState;
      setState(() {
        _isPlaying = true;
      });
      _controller.forward();
    }

    _blocMusic.audioPlayerSet = _audioPlayer;
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
            Hero(
              tag: "ImageTag",
              child: CustomButtonWidget(
                image: "asset/image/flower.jpg",
                size: contrains.maxHeight * 0.3,
                borderWidth: 5,
              ),
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
                      modleState.title,
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
                    modleState.artist,
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
                        listener: (context, state) {},
                        builder: (context, state) {
                          _duration = state;
                          if (modleState.id != _blocMusic.nowPlayingMusic.id) {
                            _duration = Duration.zero;
                          }

                          return Expanded(
                            child: Text(
                              "${_duration.inMinutes > 9 ? _duration.inMinutes : '0' + _duration.inMinutes.toString()}:${_duration.inSeconds % 60 > 9 ? _duration.inSeconds % 60 : '0' + (_duration.inSeconds % 60).toString()}",
                              style: const TextStyle(
                                  color: AppColor.styleColor, fontSize: 16),
                            ),
                          );
                        }),
                    Text(
                      "${modleState.duration ~/ 60000 > 9 ? modleState.duration ~/ 60000 : '0' + (modleState.duration ~/ 60000).toString()}:${(modleState.duration ~/ 1000) % 60 > 9 ? (modleState.duration ~/ 1000) % 60 : '0' + (modleState.duration ~/ 1000 % 60).toString()}",
                      style: const TextStyle(
                          color: AppColor.styleColor, fontSize: 16),
                    ),
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
                            max: modleState.duration ~/ 1000,
                            min: 0,
                            value: state.inSeconds,
                            onChanged: (v) {
                              // use for change time of music

                              _audioPlayer.seek(Duration(seconds: v ~/ 1));
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

                              if (_blocMusic.isStart(modleState.id)) {
                                return;
                              }
                              final previous =
                                  _blocMusic.playPrevious(modleState.id);
                              await _audioPlayer.play(previous.path);
                              _blocMusic.nowPlayingSet = previous;
                              setState(() {
                                modleState = previous;
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
                              if (_blocMusic.audioPlayer.state ==
                                  PlayerState.PLAYING) {
                                await _audioPlayer.pause();

                                setState(() {
                                  _isPlaying = false;
                                });
                                _controller.reverse();
                              } else {
                                await _audioPlayer.play(modleState.path);

                                setState(() {
                                  _isPlaying = true;
                                });
                                _controller.forward();
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
                              if (_blocMusic.isEnd(modleState.id)) {
                                return;
                              }
                              final next = _blocMusic.playNext(modleState.id);
                              await _audioPlayer.play(next.path);
                              _blocMusic.nowPlayingSet = next;
                              setState(() {
                                modleState = next;
                              });
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
