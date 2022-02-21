import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:music_palyer/bloc/bloc_state.dart';
import 'bloc_event.dart';
import 'music_model.dart';

class BlocMusic extends Bloc<BlocEvent, BlocState> {
  List<MusicModel> _model = [];
  AudioPlayer _audioPlayer = AudioPlayer(playerId: "Base");

  bool _isOneLoopPlaying = false;
  set getListOfMusicModel(List<MusicModel> musics) {
    _model = musics;
  }

  set audioPlayerSet(AudioPlayer audioPlayer) {
    _audioPlayer = audioPlayer;
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

  BlocMusic() : super(BlocState(MusicModel.first())) {
    on<BlocEvent>((event, emit) async {
      if (event is SkipNextMusic) {
        final playingThisMusic =
            _model[findIndex(event.nextMusicId) + 1]; // next music
        await _audioPlayer.play(playingThisMusic.path, isLocal: true);
        emit(BlocState(playingThisMusic, isOneLoopPlaying: _isOneLoopPlaying));
      } else if (event is SkipPreviousMusic) {
        final playingThisMusic =
            _model[findIndex(event.previousMusicId) - 1]; // previous music
        await _audioPlayer.play(playingThisMusic.path);
        emit(BlocState(playingThisMusic, isOneLoopPlaying: _isOneLoopPlaying));
      } else if (event is PlayMusic) {
        await _audioPlayer.play(findById(event.musicId).path, isLocal: true);
        emit(BlocState(findById(event.musicId),
            isOneLoopPlaying: _isOneLoopPlaying));
      } else if (event is PauseResumeMusic) {
        if (_audioPlayer.state == PlayerState.PAUSED) {
          await _audioPlayer.resume();
        } else {
          await _audioPlayer.pause();
        }
        emit(BlocState(state.modelState));
      }
    });
  }
}
