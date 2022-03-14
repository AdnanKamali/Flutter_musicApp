import 'package:flutter/cupertino.dart';

class MusicModel {
  final int id;
  final String title;
  final String path;
  final int duration;
  final String artist;
  final Image? artworkWidget;
  bool isFavorite;
  MusicModel.first({
    this.artworkWidget,
    this.artist = "",
    this.duration = 0,
    this.id = 0,
    this.path = "",
    this.title = "",
    this.isFavorite = false,
  });
  MusicModel({
    required this.artworkWidget,
    required this.artist,
    required this.id,
    required this.path,
    required this.title,
    required this.duration,
    this.isFavorite = false,
  });
  void favoriteMusic() {
    isFavorite = !isFavorite;
  }
}
