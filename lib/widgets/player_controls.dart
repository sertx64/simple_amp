import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import '../cubits/audio_cubit.dart';
import '../models/audio_state.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        final isPlaying = state.playerState == PlayerState.playing;
        final isPaused = state.playerState == PlayerState.paused;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepPurple[900]!,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        key: const Key('previous_button'),
                        onPressed: state.audioFiles.isNotEmpty
                            ? () =>
                                context.read<AudioCubit>().playPreviousFile()
                            : null,
                        iconSize: 48.0,
                        icon: const Icon(Icons.skip_previous),
                        color: Colors.black,
                      ),
                      IconButton(
                        key: const Key('play_button'),
                        onPressed: isPlaying
                            ? null
                            : () => context.read<AudioCubit>().play(),
                        iconSize: 48.0,
                        icon: const Icon(Icons.play_arrow),
                        color: Colors.green,
                      ),
                      IconButton(
                        key: const Key('pause_button'),
                        onPressed: isPlaying
                            ? () => context.read<AudioCubit>().pause()
                            : null,
                        iconSize: 48.0,
                        icon: const Icon(Icons.pause),
                        color: Colors.blue,
                      ),
                      IconButton(
                        key: const Key('stop_button'),
                        onPressed: (isPlaying || isPaused)
                            ? () => context.read<AudioCubit>().stop()
                            : null,
                        iconSize: 48.0,
                        icon: const Icon(Icons.stop),
                        color: Colors.red,
                      ),
                      IconButton(
                        key: const Key('next_button'),
                        onPressed: state.audioFiles.isNotEmpty
                            ? () => context.read<AudioCubit>().playNextFile()
                            : null,
                        iconSize: 48.0,
                        icon: const Icon(Icons.skip_next),
                        color: Colors.black,
                      ),
                    ],
                  ),
                  if (state.duration != null && state.position != null)
                    Slider(
                      activeColor: Colors.deepPurple[900],
                      thumbColor: Colors.deepPurple[900],
                      onChanged: (value) {
                        final duration = state.duration;
                        if (duration == null) return;
                        final position = value * duration.inMilliseconds;
                        context
                            .read<AudioCubit>()
                            .seek(Duration(milliseconds: position.round()));
                      },
                      value: (state.position != null &&
                              state.duration != null &&
                              state.position!.inMilliseconds > 0 &&
                              state.position!.inMilliseconds <
                                  state.duration!.inMilliseconds)
                          ? state.position!.inMilliseconds /
                              state.duration!.inMilliseconds
                          : 0.0,
                    ),
                  Text(
                    state.position != null
                        ? '${state.position!.toString().split('.').first} / ${state.duration?.toString().split('.').first ?? ''}'
                        : state.duration != null
                            ? state.duration!.toString().split('.').first
                            : '',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.read<AudioCubit>().pickDirectory(),
                  icon: const Icon(Icons.folder_open),
                  label: const Text(
                    'Выбрать папку',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[900],
                    iconColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
