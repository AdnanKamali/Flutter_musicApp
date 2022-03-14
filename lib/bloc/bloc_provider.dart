import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:music_palyer/bloc/bloc_state.dart';
import 'bloc_event.dart';
import '../model/music_model.dart';

class BlocMusic extends Bloc<BlocEvent, BlocState> {
  List<MusicModel> _model = [];
  final AudioPlayer _audioPlayer = AudioPlayer(playerId: "Base");

  bool _isOneLoopPlaying = false;
  set getListOfMusicModel(List<MusicModel> musics) {
    _model = musics;
  }

  AudioPlayer get audioPlayer {
    return _audioPlayer;
  }

  List<MusicModel> get musics {
    '''List of Musics on phone''';
    return _model;
  }

  MusicModel findById(int id) {
    '''pass id music and get Music Modle''';
    final music = _model.firstWhere((element) => element.id == id);
    return music;
  }

  int findIndex(int id) {
    '''pass id music and get Music index in List of Musics''';
    final music = _model.indexWhere((element) => element.id == id);
    return music;
  }

  bool isEnd(int id) {
    '''pass id and find location of music and get is end of list of musics or not''';
    final index = _model.indexWhere((element) => element.id == id);
    if (index == _model.length - 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isStart(int id) {
    '''pass id and find location of music and get is start of list of musics or not''';
    final index = _model.indexWhere((element) => element.id == id);
    if (index == 0) {
      return true;
    } else {
      return false;
    }
  }

  MusicModel playNext(int id) {
    '''pass id and get get next Music Modle 
    Note: please befor use it use isEnd method
    ''';
    final index = _model.indexWhere((element) => element.id == id);
    return _model[index + 1];
  }

  MusicModel playPrevious(int id) {
    '''pass id and get get previous Music Modle 
    Note: please befor use it use isStart method
    ''';
    final index = _model.indexWhere((element) => element.id == id);
    return _model[index - 1];
  }

  set isOneLoopPlayingSet(bool isOneLoopPlayingArg) {
    _isOneLoopPlaying = isOneLoopPlayingArg;
  }

  bool get isOneLoopPlaying {
    return _isOneLoopPlaying;
  }

  void _whenCompleteMusic() {
    _audioPlayer.onPlayerCompletion.listen((event) {
      if (_isOneLoopPlaying) {
        add(PlayMusic(state.modelState.id));
      } else {
        add(StopMusic());
      }
    });
  }

  BlocMusic() : super(BlocState(MusicModel.first())) {
    on<BlocEvent>((event, emit) async {
      if (event is SkipNextMusic) {
        if (!isEnd(event.nextMusicId)) {
          final playingThisMusic =
              _model[findIndex(event.nextMusicId) + 1]; // next music

          await _audioPlayer.play(playingThisMusic.path, isLocal: true);
          emit(
              BlocState(playingThisMusic, isOneLoopPlaying: _isOneLoopPlaying));
        }
      } else if (event is SkipPreviousMusic) {
        if (!isStart(event.previousMusicId)) {
          final playingThisMusic =
              _model[findIndex(event.previousMusicId) - 1]; // previous music

          await _audioPlayer.play(playingThisMusic.path);
          emit(
              BlocState(playingThisMusic, isOneLoopPlaying: _isOneLoopPlaying));
        }
      } else if (event is PlayMusic) {
        final readyToPlayMusic = findById(event.musicId);

        await _audioPlayer.play(readyToPlayMusic.path, isLocal: true);
        _whenCompleteMusic();
        emit(BlocState(readyToPlayMusic, isOneLoopPlaying: _isOneLoopPlaying));
      } else if (event is PauseResumeMusic) {
        if (_audioPlayer.state == PlayerState.PAUSED) {
          await _audioPlayer.resume();
          _whenCompleteMusic();
        } else {
          await _audioPlayer.pause();
        }
        emit(BlocState(state.modelState));
      } else if (event is SetValue) {
        emit(BlocState(event.musicModel));
      } else {
        await _audioPlayer.stop();
        emit(BlocState(state.modelState));
      }
    });
  }
}
