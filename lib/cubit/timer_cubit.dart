import 'dart:async';
import 'package:bloc/bloc.dart';

class TimerCubit extends Cubit<Duration> {
  TimerCubit() : super(const Duration(seconds: 0));
  Duration time = Duration.zero;

  void timer(Stream<Duration> duration) {
    duration.listen((event) {
      time = event;
      emit(event);
    });
  }
}
