import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_stream/audio_player/bloc/audio_player_bloc.dart';

class AudioInformation extends StatelessWidget {
  const AudioInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerBloc = BlocProvider.of<AudioPlayerBloc>(context);
    // final audioQueue = audioPlayerBloc.audioQueue;

    // debugPrint(audioPlayerBloc.audioQueue.length.toString());
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(builder: (_, state) {
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   textDirection: TextDirection.ltr,
      //   children: [
      if (state.isPlaying) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Colors.black45, blurRadius: 15)
                  ]),
                  child: Card(
                    elevation: 20.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                        "https://e0.pxfuel.com/wallpapers/807/950/desktop-wallpaper-life-2022-movie.jpg"
                        // "${state.audioQueue?.elementAt(state.currentIndex).thumbnail}"
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: SizedBox(
                  // width: 100,
                  // height: 100,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "kdfaoijfoewifn",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "another ekfweoifeoifeow",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

        // GestureDetector(
        //   child: const Icon(
        //     Icons.file_download_done_outlined,
        //     color: Colors.black,
        //     textDirection: TextDirection.ltr,
        //   ),
        //   onTap: () {},
        // )
        //   ],
        // ),
      }
      return Center(
        child: Text("Not Playing"),
      );
    });
  }
}
