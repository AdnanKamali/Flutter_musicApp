import 'package:audioplayers/audioplayers.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_palyer/bloc/bloc_event.dart';
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
  late AudioPlayer _audioPlayer;
  late AnimationController _controller;
  late MusicModleState modleState;
  @override
  void initState() {
    super.initState();
    modleState = widget.modle;
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void timerSetMax(Future<int> miliSecond) async {
    maxTime = await miliSecond;
  }

  int _timer = 0;
  bool isNextOrPervious = false;
  bool isPlaying = false;
  int maxTime = 0;
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    final timerCubit = BlocProvider.of<TimerCubit>(context);

    timerCubit.timer(_audioPlayer.onAudioPositionChanged);

    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: SafeArea(
        child:
            BlocBuilder<BlocMusic, MusicModleState>(builder: (context, state) {
          _audioPlayer.onPlayerStateChanged.listen((myState) {
            print(myState);
            if (myState == PlayerState.COMPLETED && isPlaying) {
              print("Not Playing");
              setState(() {
                isPlaying = false;
                _timer = 0;
              });
              _audioPlayer.stop();
              _controller.reverse();
            }
            if (myState == PlayerState.PLAYING) {
              isPlaying = true;
            }
          });
          timerSetMax(_audioPlayer.getDuration());
          _audioPlayer.onPlayerError.listen((event) {
            _audioPlayer.play(state.path);
          });
          if (isNextOrPervious) {
            _audioPlayer.play(state.path);
            _controller.forward();
            isPlaying = true;
            isNextOrPervious = false;
          }
          state = state.id.isEmpty ? modleState : state;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                    CustomButtonWidget(
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.menu,
                          color: AppColor.styleColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Hero(
                tag: "ImageTag",
                child: CustomButtonWidget(
                  image: "asset/image/flower.jpg",
                  size: 250,
                  borderWidth: 5,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              FittedBox(
                child: Text(
                  state.title,
                  style:
                      const TextStyle(color: AppColor.styleColor, fontSize: 29),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FittedBox(
                child: Text(
                  state.artist,
                  style: TextStyle(
                      color: AppColor.styleColor.withOpacity(0.4),
                      fontSize: 23),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 18,
                  ),
                  Expanded(
                      child: BlocConsumer<TimerCubit, Duration>(
                    listener: (context, state1) async {
                      setState(() {
                        _timer = state1.inMilliseconds;
                      });
                    },
                    builder: (context, state2) {
                      final second = state2.inSeconds > 59
                          ? (state2.inSeconds % 60)
                          : state2.inSeconds;
                      final secondTime = second > 9 ? "$second" : "0$second";
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${state2.inMinutes}:$secondTime",
                            style: const TextStyle(color: AppColor.styleColor),
                          ),
                          Text(
                            "${maxTime ~/ 60000}:${(maxTime ~/ 1000) % 60}",
                            style: const TextStyle(color: AppColor.styleColor),
                          ),
                        ],
                      );
                    },
                  )),
                  const SizedBox(
                    width: 25,
                  ),
                ],
              ),
              SfSliderTheme(
                  data: SfSliderTheme.of(context).copyWith(
                    thumbStrokeWidth: 8,
                    thumbStrokeColor: AppColor.mainColor,
                    activeDividerColor: AppColor.styleColor,
                    inactiveDividerColor: AppColor.styleColor.withAlpha(90),
                    thumbColor: AppColor.darkBlue,
                    thumbRadius: 15,
                  ), // pre good library
                  child: SfSlider(
                    max: maxTime + 1,
                    min: 0,
                    value: _timer,
                    onChanged: (v) async {
                      // use for change time of music
                      _audioPlayer.setUrl(state.path, isLocal: true);

                      _timer = v ~/ 1;

                      _audioPlayer.seek(Duration(milliseconds: _timer));
                    },
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomButtonWidget(
                      size: 80,
                      child: IconButton(
                        onPressed: () {
                          // Skip Previous Button...
                          if (bloc.isStart(state.id)) {
                            return;
                          }
                          bloc.add(SkipPreviousMusic(
                              state.id, _audioPlayer.playerId));

                          _controller.reverse();
                          _timer = 0;
                          isNextOrPervious = true;
                        },
                        icon: const Icon(Icons.skip_previous),
                      ),
                    ),
                    CustomButtonWidget(
                      // Play button...
                      borderWidth: 0,
                      isOnPressed: true,
                      size: 80,
                      child: IconButton(
                        onPressed: () {
                          if (!isPlaying) {
                            _audioPlayer.play(state.path, isLocal: true);
                            _controller.forward();
                            setState(() {
                              isPlaying = true;
                            });
                          } else {
                            _audioPlayer.pause();
                            _controller.reverse();
                            setState(() {
                              isPlaying = false;
                            });
                          }
                        },
                        icon: AnimatedIcon(
                          progress: _controller,
                          icon: AnimatedIcons.play_pause,
                          color: isPlaying ? Colors.white : AppColor.styleColor,
                        ),
                      ),
                    ),
                    CustomButtonWidget(
                      size: 80,
                      child: IconButton(
                        onPressed: () {
                          // Skip Next Button...
                          if (bloc.isEnd(state.id)) {
                            return;
                          }
                          bloc.add(
                              SkipNextMusic(state.id, _audioPlayer.playerId));
                          if (_audioPlayer.state != PlayerState.STOPPED) {
                            _audioPlayer.stop();
                            _controller.reverse();
                          }

                          _timer = 0;
                          isNextOrPervious = true;
                        },
                        icon: const Icon(Icons.skip_next),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
