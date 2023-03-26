import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'audio_player_event.dart';

part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AudioPlayer audioPlayer;

  final channel =
      WebSocketChannel.connect(Uri.parse("ws://localhost:8000/ws/stream/"));

  int currentIndex = 0;
  bool isPlaying = false;
  bool finishedQueue = false;

  void initialize() async {}

  AudioPlayerBloc({
    required this.audioPlayer,
  }) : super(AudioPlayerState(audioPlayer: audioPlayer)) {
    AudioPlayer.logEnabled = false;
    state.audioPlayer.onPlayerCompletion.listen((event) {
      add(PlayNextEvent());
    });

    state.audioPlayer.onPlayerError.listen((event) {
      add(AudioPlayerFailedEvent(errorMessage: event.toString()));
    });

    channel.stream.listen((data) {
      var jsonData = json.decode(data);
      String op = jsonData['operation'];
      switch (op) {
        case "PLAY":
          String url = jsonData['url'];
          add(PlayAudioEvent(audio: url));
          break;

        case "PAUSE":
          add(PauseAudioEvent());
          break;

        case "RESUME":
          add(ResumeAudioEvent());
          break;

        case "SEEK":
          int seekSeconds = jsonData['seek'];
          add(SeekAudioEvent(newPosition: Duration(seconds: seekSeconds)));
          break;
      }
    });

    initialize();

    on<PlayAudioEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: AudioPlayerStatus.playing,
          channel: channel,
          isPlaying: true,
          currentIndex: currentIndex,
        ),
      );
      await state.audioPlayer.play(
        event.audio,
      );
    });

    on<ResumeAudioEvent>((event, emit) async {
      await state.audioPlayer.resume();
      emit(state.copyWith(
        status: AudioPlayerStatus.playing,
      ));
    });

    on<PauseAudioEvent>((event, emit) async {
      await state.audioPlayer.pause().then((value) {
        emit(state.copyWith(status: AudioPlayerStatus.paused));
      });
    });

    on<StopAudioEvent>((event, emit) async {
      isPlaying = false;
      currentIndex = 0;
      await state.audioPlayer.stop();
      emit(state.copyWith(isPlaying: false, currentIndex: currentIndex));
    });

    on<PlayNextEvent>((event, emit) async {
      await state.audioPlayer.stop();

      emit(state.copyWith(
        audioPlayer: audioPlayer,
        currentIndex: currentIndex,
        status: AudioPlayerStatus.loading,
      ));
    });

    on<PlayPreviousEvent>((event, emit) async {
      await state.audioPlayer.stop();

      AudioPlayerStatus prevState = state.status;
      emit(state.copyWith(
          audioPlayer: audioPlayer,
          currentIndex: currentIndex,
          status: AudioPlayerStatus.loading));
    });

    on<SeekAudioEvent>((event, emit) async {
      await state.audioPlayer.seek(event.newPosition);
    });

    on<AudioPlayerFailedEvent>((event, emit) async {
      emit(state.copyWith(
        status: AudioPlayerStatus.failure,
        isPlaying: false,
      ));
    });
  }

  Stream<Duration> currentPosition() async* {
    yield* audioPlayer.onAudioPositionChanged;
  }

  Stream<Duration> fileDuration() async* {
    yield* audioPlayer.onDurationChanged;
  }

  void sendMessage(String operation, String? url, int? seconds) {
    var body = jsonEncode({
      "operation": operation,
      "url": url,
      "seek": seconds,
    });

    channel.sink.add(body);
  }

// Stream receiveMessages() async* {
//   yield channel.stream;
// }
}
