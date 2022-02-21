import 'package:music_palyer/bloc/music_model.dart';

class BlocState {
  final MusicModel modelState;
  final bool isOneLoopPlaying;

  BlocState(this.modelState, {this.isOneLoopPlaying = false});
}
