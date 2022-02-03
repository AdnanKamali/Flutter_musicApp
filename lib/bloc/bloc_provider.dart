import 'package:bloc/bloc.dart';
import 'package:music_palyer/bloc/bloc_event.dart';
import 'package:music_palyer/bloc/bloc_state.dart';
import 'package:music_palyer/model/music_model.dart';

class BlocMusic extends Bloc<BlocEvent, BlocState> {
  BlocMusic() : super(BlocState(false, MusicModle.first().id)) {
    on<BlocEvent>((event, emit) {
      if (event is PlayMusic) {
        emit(
          BlocState(true, event.idMusicForPlay),
        );
      } else if (event is PauseMusic) {
        emit(BlocState(false, event.idMusic));
      }
    });
  }
}
