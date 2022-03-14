import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_palyer/bloc/bloc_event.dart';
import 'package:music_palyer/bloc/bloc_provider.dart';
import 'package:music_palyer/bloc/bloc_state.dart';
import 'package:music_palyer/resource/string_manager.dart';
import 'package:music_palyer/screen/detail_page.dart';
import 'package:music_palyer/widget/custom_button_widget.dart';
import 'package:music_palyer/model/music_model.dart';
import 'package:music_palyer/widget/list_of_song.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../resource/styles/color_manager.dart';
import '../resource/styles/style_manager.dart';
import '../widget/image_music_shower.dart';
import '../widget/list_of_song.dart';

class ListPage extends StatefulWidget {
  final List<MusicModel> musics;
  const ListPage({Key? key, required this.musics}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool isFavorit = false;
  bool isMuteVolume = false;
  // Timer _timerHiddenVolume() {
  //   return Timer.periodic(const Duration(seconds: 2), (timer) {
  //     setState(() {
  //       isChangeVolume = false;
  //     });
  //     timer.cancel();
  //   });
  // }

  late Timer whenStartTimer;

  String id = "";
  double changeVolume = 0;
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    final bool isEmptyMusics = bloc.musics.first.path.isEmpty;
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColor.mainColor,
        title: Text(
          StringManager.titleOfSongs,
          style: getTitileStyle(fontWeight: FontWeight.w300),
        ),
      ),
      body: BlocBuilder<BlocMusic, BlocState>(builder: (context, state) {
        final bool isFirstTouchToDetail = state.modelState.title.isEmpty;
        final Image? imageOfMusic = state.modelState.artworkWidget;
        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButtonWidget(
                        borderWidth: 3,
                        isOnPressed: isFavorit,
                        child: IconButton(
                          onPressed: () {
                            // I will Update Favorit button
                            setState(() {
                              isFavorit = !isFavorit;
                            });
                          },
                          icon: const Icon(
                            Icons.favorite,
                            color: AppColor.styleColor,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: isEmptyMusics
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (c) {
                                    bloc.add(SetValue(isFirstTouchToDetail
                                        ? bloc.musics[0]
                                        : state.modelState));
                                    return DetailPage(
                                      model: isFirstTouchToDetail
                                          ? bloc.musics[0]
                                          : state.modelState,
                                      newModel: isFirstTouchToDetail
                                          ? bloc.musics[0]
                                          : state.modelState,
                                    );
                                  }),
                                );
                              },
                        child: ImageMusicShow(
                          imageOfMusic: imageOfMusic,
                          size: 150,
                        ),
                      ),
                      CustomButtonWidget(
                        child: IconButton(
                          onPressed: () async {
                            setState(() {
                              isMuteVolume = !isMuteVolume;
                            });
                            if (isMuteVolume) {
                              await bloc.audioPlayer.setVolume(0);
                            } else {
                              await bloc.audioPlayer.setVolume(1);
                            }
                          },
                          icon: Icon(
                            isMuteVolume ? Icons.volume_mute : Icons.volume_up,
                            color: AppColor.styleColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  width: 290,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: AppColor.activeColor,
                    border: Border.all(color: AppColor.mainColor),
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.darkBlue,
                            borderRadius: BorderRadius.circular(65),
                          ),
                          width: 145,
                          height: 60,
                        ),
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "All",
                              style:
                                  getTitileStyle(color: AppColor.activeColor),
                            ),
                            Text(
                              "Favorite",
                              style: getTitileStyle(),
                            ),
                          ]),
                    ],
                  ),
                ),
                Expanded(
                  child: isEmptyMusics
                      ? _notFoundMusic()
                      : ListOfSong(currentPlayMusic: state.modelState),
                ),
              ],
            ),
            _bottomShadow()
          ],
        );
      }),
    );
  }

  Widget _notFoundMusic() {
    return Scaffold(
      body: Center(
        child: Text(
          StringManager.notFound,
          style: getTitileStyle(),
        ),
      ),
    );
  }

  Widget _bottomShadow() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Text(
          StringManager.poweredBy,
          style: getSubTitleStyle(),
        ),
        height: 20,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppColor.mainColor.withOpacity(0),
            AppColor.mainColor.withOpacity(0.75),
            AppColor.mainColor
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
      ),
    );
  }
}
