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
        final color = Theme.of(context).primaryColor;
        final isPlaying = state.playerState == PlayerState.playing;
        final isPaused = state.playerState == PlayerState.paused;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  key: const Key('play_button'),
                  onPressed: isPlaying ? null : () => context.read<AudioCubit>().play(),
                  iconSize: 48.0,
                  icon: const Icon(Icons.play_arrow),
                  color: color,
                ),
                IconButton(
                  key: const Key('pause_button'),
                  onPressed: isPlaying ? () => context.read<AudioCubit>().pause() : null,
                  iconSize: 48.0,
                  icon: const Icon(Icons.pause),
                  color: color,
                ),
                IconButton(
                  key: const Key('stop_button'),
                  onPressed: (isPlaying || isPaused) ? () => context.read<AudioCubit>().stop() : null,
                  iconSize: 48.0,
                  icon: const Icon(Icons.stop),
                  color: color,
                ),
              ],
            ),
            if (state.duration != null && state.position != null)
              Slider(
                onChanged: (value) {
                  final duration = state.duration;
                  if (duration == null) return;
                  final position = value * duration.inMilliseconds;
                  context.read<AudioCubit>().seek(Duration(milliseconds: position.round()));
                },
                value: (state.position != null &&
                        state.duration != null &&
                        state.position!.inMilliseconds > 0 &&
                        state.position!.inMilliseconds < state.duration!.inMilliseconds)
                    ? state.position!.inMilliseconds / state.duration!.inMilliseconds
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
        );
      },
    );
  }
} 