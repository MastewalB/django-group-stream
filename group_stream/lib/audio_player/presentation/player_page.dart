import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_stream/audio_player/bloc/audio_player_bloc.dart';
import 'package:group_stream/audio_player/presentation/widgets/widgets.dart';

class PlayerPage extends StatelessWidget {

  static const String routeName = "/player";

  const PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final audioPlayerBloc = BlocProvider.of<AudioPlayerBloc>(context);

    // debugPrint(audioPlayerBloc.audioQueue.length.toString());
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(Colors.grey.shade900.value),
                Color(Colors.grey.shade50.value)
              ],
              begin: const FractionalOffset(0.0, 1.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
            color: Colors.black
        ),
        child: ListView(
          children: [
            PlayerAppBar(),
            AudioInformation(),
            TimeSlider(),
            PlayerControls(),
          ],
        ),
      ),
    );
  }
}
