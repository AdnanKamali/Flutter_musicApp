import 'package:flutter/material.dart';
import 'package:music_palyer/list_page.dart';

import '../custom_button_widget.dart';
import '../my_colors.dart';

class ListOfSong extends StatefulWidget {
  ListOfSong({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ListPage widget;

  @override
  State<ListOfSong> createState() => _ListOfSongState();
}

class _ListOfSongState extends State<ListOfSong> {
  String _id = "";
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.widget.musics.length,
        itemBuilder: (ctx, index) {
          final _musicList = widget.widget.musics;
          final _durationMiliseccond = _musicList[index].duration.round();
          final _durationMinute = (_durationMiliseccond ~/ 60000);
          final _durationSeccond =
              (((_durationMiliseccond / 60000) - _durationMinute) * 60).round();
          return Container(
            decoration: BoxDecoration(
                color: _id == _musicList[index].id
                    ? AppColor.activeColor
                    : AppColor.mainColor,
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _musicList[index].title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppColor.styleColor,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _musicList[index].artist,
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
                  isOnPressed: _id == _musicList[index].id,
                  child: IconButton(
                    icon: Icon(
                      _id == _musicList[index].id
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: _id == _musicList[index].id
                          ? Colors.white
                          : AppColor.styleColor,
                    ),
                    onPressed: () {
                      // send Event play
                      setState(() {
                        // send to bloc id and set to play
                        if (_id == _musicList[index].id) {
                          _id = "";
                        } else {
                          _id = _musicList[index].id;
                          print(_id);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
