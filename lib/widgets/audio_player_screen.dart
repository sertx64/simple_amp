import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/audio_cubit.dart';
import 'player_controls.dart';
import 'audio_files_list.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioCubit(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Simple Amp'),
          ),
          body: Column(
            children: [
              const PlayerControls(),
              ElevatedButton(
                onPressed: () => context.read<AudioCubit>().pickDirectory(),
                child: const Text('Выбрать папку'),
              ),
              const Expanded(
                child: AudioFilesList(),
              ),

            ],
          ),
        ),
      ),
    );
  }
} 