import 'package:bloc/bloc.dart';
import 'bloc_event.dart';
import 'music_model.dart';

class BlocMusic extends Bloc<BlocEvent, MusicModleState> {
  List<MusicModleState> _modle = [];
  MusicModleState nowPlayingMusic = MusicModleState.first();
  void getListOfMusicModleState(List<MusicModleState> musics) {
    _modle = musics;
  }

  List<MusicModleState> get musics {
    return _modle;
  }

  set nowPlaying(MusicModleState modleState) {
    nowPlayingMusic = modleState;
  }

  MusicModleState findById(String id) {
    if (id.isEmpty && nowPlayingMusic == MusicModleState.first()) {
      print("No One");
      return _modle[0];
    } else if (nowPlayingMusic != MusicModleState.first()) {
      return nowPlayingMusic;
    }
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

  BlocMusic() : super(MusicModleState.first()) {
    on<BlocEvent>((event, emit) {
      if (event is PlayMusic) {
        emit(findById(event.idMusicForPlay));
      } else if (event is PauseMusic) {
        emit(findById(event.idMusic));
      } else if (event is SkipNextMusic) {
        emit(_modle[findIndex(event.nextMusicId) + 1]);
      } else if (event is SkipPreviousMusic) {
        emit(_modle[findIndex(event.previousMusicId) - 1]);
      }
    });
  }
}
