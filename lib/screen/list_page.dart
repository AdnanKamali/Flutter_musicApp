import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_palyer/bloc/bloc_provider.dart';
import 'package:music_palyer/cubit/timer_cubit.dart';
import 'package:music_palyer/screen/detail_page.dart';
import 'package:music_palyer/widget/custom_button_widget.dart';
import 'package:music_palyer/model/music_model.dart';
import 'package:music_palyer/my_colors.dart';
import 'package:music_palyer/widget/list_of_song.dart';

import '../widget/list_of_song.dart';

class ListPage extends StatefulWidget {
  final List<MusicModle> musics;
  const ListPage({Key? key, required this.musics}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool isFavorit = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => BlocMusic(),
        child: Scaffold(
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
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (c) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider(create: (c) => BlocMusic()),
                                      BlocProvider(create: (c) => TimerCubit())
                                    ],
                                    child: DetailPage(
                                      modle: widget.musics[0],
                                    )),
                              ),
                            ); // use true value
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
        ));
  }
}
