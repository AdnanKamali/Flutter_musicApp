import 'package:audioplayers/audioplayers.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_palyer/bloc/bloc_event.dart';
import 'package:music_palyer/bloc/bloc_provider.dart';
import 'package:music_palyer/cubit/timer_cubit.dart';
import 'package:music_palyer/model/music_model.dart';
import 'package:music_palyer/my_colors.dart';
import 'package:music_palyer/widget/custom_button_widget.dart';
import 'package:pausable_timer/pausable_timer.dart';
// import 'package:music_palyer/widget/custom_progress_widget.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DetailPage extends StatefulWidget {
  final MusicModle modle;
  const DetailPage({Key? key, required this.modle}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _controller;
  late Duration _durationMusic;
  @override
  void initState() {
    super.initState();
    _durationMusic = Duration(milliseconds: (widget.modle.duration ~/ 1));
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  int _timer = 0;
  // double value = 0;
  bool isPlaying = false;
  int currentPause = 0;
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    final timerCubit = BlocProvider.of<TimerCubit>(context);
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      body: SafeArea(
        child: Column(
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
                widget.modle.title,
                style:
                    const TextStyle(color: AppColor.styleColor, fontSize: 29),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FittedBox(
              child: Text(
                widget.modle.artist,
                style: TextStyle(
                    color: AppColor.styleColor.withOpacity(0.4), fontSize: 23),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: BlocConsumer<TimerCubit, int>(
                  listener: (context, state) {
                    setState(() {
                      _timer = state;
                    });
                  },
                  builder: (context, state) => Text("${state}"),
                  // listener: (context, state) => print(state),
                )),
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
                  max: widget.modle.duration ~/ 1000,
                  min: 0,
                  value: _timer,
                  onChanged: (v) {
                    // use for change time of music
                    setState(() {
                      _timer = v ~/ 1;
                    });
                    timerCubit.seekTime(v ~/ 1);
                    _audioPlayer.seek(Duration(milliseconds: _timer * 1000));
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
                      onPressed: () {},
                      icon: const Icon(Icons.skip_previous),
                    ),
                  ),
                  CustomButtonWidget(
                    // Play button
                    borderWidth: 0,
                    isOnPressed: true,
                    size: 80,
                    child: IconButton(
                      onPressed: () {
                        timerCubit.cancelTimer(50);
                      },
                      icon: AnimatedIcon(
                        progress: _controller,
                        icon: AnimatedIcons.play_pause,
                        color: isPlaying ? AppColor.styleColor : Colors.white,
                      ),
                    ),
                  ),
                  CustomButtonWidget(
                    size: 80,
                    child: IconButton(
                      onPressed: () {
                        timerCubit.startTimer(180);
                      },
                      icon: const Icon(Icons.skip_next),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
 // CustomTimer(
                    //     controller: _timerController,
                    //     end: Duration(milliseconds: widget.modle.duration ~/ 1),
                    //     begin: Duration(seconds: _start),
                    //     builder: (time) {
                    //       int _start1 = (int.parse(time.minutes) * 60) +
                    //           int.parse(time.seconds);
                    //       return Text(
                    //         "${time.minutes}:${time.seconds}",
                    //         style: const TextStyle(color: AppColor.styleColor),
                    //       );
                    //     }),