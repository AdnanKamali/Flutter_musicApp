import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_palyer/bloc/bloc_event.dart';
import 'package:music_palyer/bloc/bloc_provider.dart';
import 'package:music_palyer/screen/detail_page.dart';
import 'package:music_palyer/screen/list_page.dart';
import 'custom_button_widget.dart';
import '../my_colors.dart';

class ListOfSong extends StatefulWidget {
  const ListOfSong({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ListPage widget;

  @override
  State<ListOfSong> createState() => _ListOfSongState();
}

class _ListOfSongState extends State<ListOfSong>
    with SingleTickerProviderStateMixin {
  String _id = "";
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BlocMusic>(context);
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: bloc.musics.length,
        itemBuilder: (ctx, index) {
          // final _musicList = widget.widget.musics;
          // final _durationMiliseccond = _musicList[index].duration.round();
          // final _durationMinute = (_durationMiliseccond ~/ 60000);
          // final _durationSeccond =
          //     (((_durationMiliseccond / 60000) - _durationMinute) * 60).round();
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
                color: _id == bloc.musics[index].id
                    ? AppColor.activeColor
                    : AppColor.mainColor,
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (c) {
                      bloc.add(NewMusicPlay(bloc.musics[index].id));
                      return DetailPage(
                        modle: bloc.musics[index],
                      );
                    },
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bloc.musics[index].title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: AppColor.styleColor,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        bloc.musics[index].artist,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: AppColor.styleColor,
                          fontSize: 16,
                        ),
                      ),
                      // Text(
                      //   "${_durationMinute > 9 ? _durationMinute : "0" + _durationMinute.toString()}:${_durationSeccond > 9 ? _durationMinute : "0" + _durationSeccond.toString()}",
                      //   style: const TextStyle(
                      //     color: AppColor.styleColor,
                      //     fontSize: 16,
                      //   ),
                      // ),
                    ],
                  ),
                  CustomButtonWidget(
                    isOnPressed: _id == bloc.musics[index].id,
                    child: IconButton(
                      icon: _id == bloc.musics[index].id
                          ? AnimatedIcon(
                              progress: _controller,
                              icon: AnimatedIcons.play_pause,
                              color: _id == bloc.musics[index].id
                                  ? Colors.white
                                  : AppColor.styleColor,
                            )
                          : const Icon(Icons.play_arrow),
                      onPressed: () {
                        // send Event play

                        setState(() {
                          // send to bloc id and set to play
                          if (_id == bloc.musics[index].id) {
                            if (_controller.isCompleted) {
                              _controller.reverse();
                            }

                            _id = "";
                          } else {
                            // _controller.reverse();

                            if (_controller.isCompleted) {
                              _controller.forward(from: 0);
                            }
                            _controller.forward();
                            _id = bloc.musics[index].id;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
