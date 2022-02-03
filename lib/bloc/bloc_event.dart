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

  SkipNextMusic(this.nextMusicId);
}

class SkipPreviousMusic extends BlocEvent {
  final String previousMusicId;

  SkipPreviousMusic(this.previousMusicId);
}
