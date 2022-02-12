import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_palyer/bloc/bloc_provider.dart';

import 'package:music_palyer/screen/detail_page.dart';
import 'package:music_palyer/styles/style_manager.dart';
import 'package:music_palyer/widget/custom_button_widget.dart';
import 'package:music_palyer/bloc/music_model.dart';
import 'package:music_palyer/styles/color_manager.dart';
import 'package:music_palyer/widget/list_of_song.dart';

import '../widget/list_of_song.dart';

class ListPage extends StatefulWidget {
  final List<MusicModleState> musics;
  const ListPage({Key? key, required this.musics}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool isFavorit = false;
  String id = "";
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
          "List of Song",
          style: getTitileStyle(fontWeight: FontWeight.w300),
        ),
      ),
      body: Stack(
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
                          // I will Update
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
                                  MusicModleState modleState;
                                  if (bloc.isHaveCurrentPlay) {
                                    modleState = bloc.currentPlay;
                                  } else {
                                    modleState = bloc.musics[0];
                                    bloc.nowPlayingSet = modleState;
                                  }

                                  return DetailPage(
                                    modle: modleState,
                                  );
                                }),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                      child: const Hero(
                        tag: "ImageTag",
                        child: CustomButtonWidget(
                          size: 150,
                          borderWidth: 5,
                          image: "asset/image/flower.jpg",
                        ),
                      ),
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
              Expanded(
                child: isEmptyMusics
                    ? const Center(
                        child: Text("Not Found"),
                      )
                    : ListOfSong(
                        widget: widget,
                        id: id,
                      ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppColor.mainColor.withOpacity(0),
                  AppColor.mainColor
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
