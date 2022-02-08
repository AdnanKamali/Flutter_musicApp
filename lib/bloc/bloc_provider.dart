import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'bloc_event.dart';
import 'music_model.dart';

class BlocMusic extends Bloc<BlocEvent, MusicModleState> {
  List<MusicModleState> _modle = [];
  AudioPlayer _audioPlayer = AudioPlayer(playerId: "Base");
  MusicModleState nowPlayingMusic = MusicModleState.first();
  set getListOfMusicModleState(List<MusicModleState> musics) {
    _modle = musics;
  }

  set audioPlayerSet(AudioPlayer audioPlayer) {
    _audioPlayer = audioPlayer;
  }

  AudioPlayer get audioPlayer {
    return _audioPlayer;
  }

  List<MusicModleState> get musics {
    return _modle;
  }

  set nowPlayingSet(MusicModleState modleState) {
    nowPlayingMusic = modleState;
  }

  MusicModleState findById(String id) {
    final music = _modle.firstWhere((element) => element.id == id);
    return music;
  }

  int findIndex(String id) {
    final music = _modle.indexWhere((element) => element.id == id);
    return music;
  }

  bool isEnd(String id) {
    final index = _modle.indexWhere((element) => element.id == id);
    if (index == _modle.length - 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isStart(String id) {
    final index = _modle.indexWhere((element) => element.id == id);
    if (index == 0) {
      return true;
    } else {
      return false;
    }
  }

  MusicModleState playNext(String id) {
    final index = _modle.indexWhere((element) => element.id == id);
    return _modle[index + 1];
  }

  MusicModleState playPrevious(String id) {
    final index = _modle.indexWhere((element) => element.id == id);
    return _modle[index - 1];
  }

  MusicModleState get currentPlay {
    return nowPlayingMusic;
  }

  bool get isHaveCurrentPlay {
    if (nowPlayingMusic.id.isEmpty) {
      return false;
    }
    return true;
  }

  BlocMusic() : super(MusicModleState.first()) {
    on<BlocEvent>((event, emit) {
      if (event is PlayMusic) {
        emit(findById(event.idMusicForPlay));
      } else if (event is PauseMusic) {
        emit(findById(event.idMusic));
      } else if (event is SkipNextMusic) {
        nowPlayingSet = _modle[findIndex(event.nextMusicId) + 1];
        emit(_modle[findIndex(event.nextMusicId) + 1]);
      } else if (event is SkipPreviousMusic) {
        emit(_modle[findIndex(event.previousMusicId) - 1]);
      } else if (event is NewMusicPlay) {
        emit(findById(event.id));
      }
    });
  }
}
