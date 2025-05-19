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
            title: Text(
                style: TextStyle(
                  color: Colors.deepPurple[900],
                ),
                'Simple Amp'),
          ),
          body: Column(
            children: [
              const PlayerControls(),
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