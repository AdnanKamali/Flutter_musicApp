import 'package:audioplayers/audioplayers.dart';

abstract class BlocEvent {}

class SkipNextMusic extends BlocEvent {
  final String nextMusicId;
  final AudioPlayer _audioPlayer;
  SkipNextMusic(this.nextMusicId, this._audioPlayer) {
    if (_audioPlayer.state != PlayerState.COMPLETED) {
      _audioPlayer.stop();
    }
  }
}

class SkipPreviousMusic extends BlocEvent {
  final String previousMusicId;
  final AudioPlayer _audioPlayer;
  SkipPreviousMusic(this.previousMusicId, this._audioPlayer) {
    if (_audioPlayer.state != PlayerState.COMPLETED) {
      _audioPlayer.stop();
    }
  }
}

class NewMusicPlay extends BlocEvent {
  final String id;

  NewMusicPlay(this.id);
}
