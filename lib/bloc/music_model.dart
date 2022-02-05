class MusicModleState {
  final String id;
  final String playerId;
  final String title;
  final String path;
  final double duration;
  final String artist;
  MusicModleState.first({
    this.playerId = "",
    this.artist = "",
    this.duration = 0,
    this.id = "",
    this.path = "",
    this.title = "",
  });
  MusicModleState({
    this.playerId = "",
    required this.artist,
    required this.id,
    required this.path,
    required this.title,
    required this.duration,
  });
}
