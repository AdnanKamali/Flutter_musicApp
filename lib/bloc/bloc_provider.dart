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
    '''List of Musics on phone''';
    return _modle;
  }

  set nowPlayingSet(MusicModleState modleState) {
    '''set now Playing music for use it later''';
    nowPlayingMusic = modleState;
  }

  MusicModleState findById(String id) {
    '''pass id music and get Music Modle''';
    final music = _modle.firstWhere((element) => element.id == id);
    return music;
  }

  int findIndex(String id) {
    '''pass id music and get Music index in List of Musics''';
    final music = _modle.indexWhere((element) => element.id == id);
    return music;
  }

  bool isEnd(String id) {
    '''pass id and find location of music and get is end of list of musics or not''';
    final index = _modle.indexWhere((element) => element.id == id);
    if (index == _modle.length - 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isStart(String id) {
    '''pass id and find location of music and get is start of list of musics or not''';
    final index = _modle.indexWhere((element) => element.id == id);
    if (index == 0) {
      return true;
    } else {
      return false;
    }
  }

  MusicModleState playNext(String id) {
    '''pass id and get get next Music Modle 
    Note: please befor use it use isEnd method
    ''';
    final index = _modle.indexWhere((element) => element.id == id);
    return _modle[index + 1];
  }

  MusicModleState playPrevious(String id) {
    '''pass id and get get previous Music Modle 
    Note: please befor use it use isStart method
    ''';
    final index = _modle.indexWhere((element) => element.id == id);
    return _modle[index - 1];
  }

  MusicModleState get currentPlay {
    '''get Now Playing Music Modle''';
    return nowPlayingMusic;
  }

  bool get isHaveCurrentPlay {
    '''with use this check is now palying set or not''';
    if (nowPlayingMusic.id.isEmpty) {
      return false;
    }
    return true;
  }

  BlocMusic() : super(MusicModleState.first()) {
    on<BlocEvent>((event, emit) {
      if (event is SkipNextMusic) {
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
