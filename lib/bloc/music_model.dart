import 'package:on_audio_query/on_audio_query.dart';

class MusicModel {
  final int id;

  final String title;
  final String path;
  final int duration;
  final String artist;
  final QueryArtworkWidget? artworkWidget;
  MusicModel.first({
    this.artworkWidget,
    this.artist = "",
    this.duration = 0,
    this.id = 0,
    this.path = "",
    this.title = "",
  });
  MusicModel({
    required this.artworkWidget,
    required this.artist,
    required this.id,
    required this.path,
    required this.title,
    required this.duration,
  });
}
