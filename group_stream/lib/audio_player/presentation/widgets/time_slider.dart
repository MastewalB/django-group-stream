import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_stream/audio_player/bloc/audio_player_bloc.dart';

class TimeSlider extends StatefulWidget {
  const TimeSlider({Key? key}) : super(key: key);

  @override
  State<TimeSlider> createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> {
  double? _dragValue;
  bool _dragging = false;

  String _getFormattedTime(Duration duration) {
    String twoDigits(int num) => num.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours.toInt() > 0) {
      return "${twoDigits(duration.inHours)}:$minutes:$seconds";
    }
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerBloc = BlocProvider.of<AudioPlayerBloc>(context);

    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(builder: (_, state) {
      if (state.status.isFailure) {
        return Center(child: Text("Playback Error"));
      } else if (state.status.isLoading || state.status.isInitial) {
        return Center(child: sliderPlaceholder());
      }
      return StreamBuilder(
        stream: audioPlayerBloc.fileDuration(),
        builder: (_, AsyncSnapshot<Duration> totalDurationSnapshot) =>
            StreamBuilder(
          stream: audioPlayerBloc.currentPosition(),
          builder: (_, AsyncSnapshot<Duration> snapshot) {
            // debugPrint("$snapshot ${snapshot.hasData} ${snapshot.data}");
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return sliderPlaceholder();
              case ConnectionState.active:
                return sliderPlaceholder();
              case ConnectionState.done:
                return sliderPlaceholder();
              case ConnectionState.waiting:
                if (snapshot.hasData && totalDurationSnapshot.hasData) {
                  int seconds = snapshot.data!.inSeconds;
                  Duration duration = snapshot.data!;
                  Duration totalDuration = totalDurationSnapshot.data!;

                  final value = min(
                    _dragValue ?? duration.inMilliseconds.toDouble(),
                    totalDuration.inMilliseconds.toDouble(),
                  );
                  if (_dragValue != null && !_dragging) {
                    _dragValue = null;
                  }

                  return Column(
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: SliderTheme(
                          data: const SliderThemeData(
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: Colors.grey,
                            thumbColor: Colors.white,
                          ),
                          child: Slider(
                            max: totalDuration.inMilliseconds.toDouble(),
                            value: value,
                            onChanged: (double value) {
                              if (!_dragging) {
                                _dragging = true;
                              }
                              setState(() {
                                _dragValue = value;
                              });
                              int s = value ~/ 1000;
                              audioPlayerBloc.add(
                                SeekAudioEvent(
                                  newPosition: Duration(
                                    milliseconds: value.toInt(),
                                  ),
                                ),
                              );

                              audioPlayerBloc.sendMessage("SEEK", null, s);
                            },
                            onChangeEnd: (value) {
                              _dragging = false;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _getFormattedTime(duration),
                              textDirection: TextDirection.ltr,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              _getFormattedTime(totalDuration),
                              textDirection: TextDirection.ltr,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }
            }

            return sliderPlaceholder();
          },
        ),
      );
    });
  }
}

Widget sliderPlaceholder() {
  return Column(
    children: [
      SizedBox(
        width: double.maxFinite,
        child: Slider(
          activeColor: Colors.white,
          inactiveColor: Colors.grey,
          value: 0,
          onChanged: (double value) {},
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "00:00",
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "00:00",
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      )
    ],
  );
}
