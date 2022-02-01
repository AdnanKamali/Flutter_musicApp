import 'package:flutter/material.dart';
import 'package:music_palyer/custom_button_widget.dart';
import 'package:music_palyer/music_model.dart';
import 'package:music_palyer/my_colors.dart';

import 'widget/list_of_song.dart';

class ListPage extends StatefulWidget {
  final List<MusicModle> musics;
  const ListPage({Key? key, required this.musics}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

bool isFavorit = false;

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColor.mainColor,
        title: const Text(
          "List of Song",
          style: TextStyle(color: AppColor.styleColor),
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
                    CustomButtonWidget(
                      size: 150,
                      borderWidth: 5,
                      image: "asset/image/flower.jpg",
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
                child: ListOfSong(
                  widget: widget,
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