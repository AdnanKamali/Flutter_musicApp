class MusicModle {
  final String id;
  final String title;
  final String path;
  final double duration;
  final String artist;
  MusicModle.first({
    this.artist = "",
    this.duration = 0,
    this.id = "",
    this.path = "",
    this.title = "",
  });
  MusicModle({
    required this.artist,
    required this.id,
    required this.path,
    required this.title,
    required this.duration,
  });
}
