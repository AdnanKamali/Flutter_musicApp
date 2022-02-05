import 'dart:async';
import 'package:bloc/bloc.dart';

class TimerCubit extends Cubit<Duration> {
  TimerCubit() : super(const Duration(seconds: 0));
  int myTime = 0;
  // Timer timer(int time) {
  //   const oneSec = Duration(seconds: 1);
  //   return Timer.periodic(oneSec, (timer) {
  //     if (myTime == time) {
  //       timer.cancel();
  //       myTime = 0;
  //       emit(myTime);
  //     } else {
  //       emit(myTime++);
  //     }
  //   });
  // }
  void timer(Stream<Duration> duration) {
    duration.listen((event) {
      emit(event);
    });
  }

  // Timer? _timer;
  // void seekTime(int second) {
  //   myTime = second;
  // }

  // void cancelTimer(int second) {
  //   if (_timer == null) {
  //     return;
  //   }
  //   myTime = second;
  //   _timer!.cancel();
  // }

  // void startTimer(int second) {
  //   // _timer = timer(second);
  // }
}
