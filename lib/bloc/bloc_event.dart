abstract class BlocEvent {}

class PlayMusic extends BlocEvent {
  final String idMusicForPlay;
  PlayMusic(this.idMusicForPlay);
}

class PauseMusic extends BlocEvent {
  final String idMusic;

  PauseMusic(this.idMusic);
}

class SkipNextMusic extends BlocEvent {
  final String nextMusicId;
  final String playerId;
  SkipNextMusic(this.nextMusicId, this.playerId);
}

class SkipPreviousMusic extends BlocEvent {
  final String previousMusicId;
  final String playerId;
  SkipPreviousMusic(this.previousMusicId, this.playerId);
}
