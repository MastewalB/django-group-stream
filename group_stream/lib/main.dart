import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_stream/audio_player/bloc/audio_player_bloc.dart';
import 'package:group_stream/audio_player/presentation/player_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => AudioPlayerBloc(audioPlayer: AudioPlayer())
          ..add(PlayAudioEvent(
              audio:
                  "https://github.com/MastewalB/competitive-programming/raw/master/Algorithms%20and%20Programming/Timelapse%20.mp3")),
        child: PlayerPage(),
      ),
    );
  }
}
