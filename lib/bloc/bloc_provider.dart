import 'package:bloc/bloc.dart';
import 'bloc_event.dart';
import 'music_model.dart';

class BlocMusic extends Bloc<BlocEvent, MusicModleState> {
  List<MusicModleState> _modle = [];
  void getListOfMusicModleState(List<MusicModleState> musics) {
    _modle = musics;
  }

  MusicModleState findById(String id) {
    final music = _modle.firstWhere((element) => element.id == id);
    return music;
  }

  int findIndex(String id) {
    final music = _modle.indexWhere((element) => element.id == id);
    return music;
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
