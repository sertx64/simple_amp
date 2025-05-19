import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/audio_cubit.dart';
import '../models/audio_state.dart';

class AudioFilesList extends StatelessWidget {
  const AudioFilesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      buildWhen: (previous, current) => 
        previous.audioFiles != current.audioFiles || 
        previous.filePath != current.filePath,
      builder: (context, state) {
        if (state.selectedDirectory == null) {
          return const Center(
            child: Text('Выберите папку с аудио файлами'),
          );
        }

        if (state.audioFiles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('В выбранной папке нет аудио файлов'),
                const SizedBox(height: 8),
                Text(
                  'Выбранная папка: ${state.selectedDirectory}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.deepPurple[900]!,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Container(
                color: Colors.deepPurple[900],
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Папка: ${state.selectedDirectory}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.audioFiles.length,
                  itemBuilder: (context, index) {
                    final filePath = state.audioFiles[index];
                    final fileName = filePath.split('/').last;
                    final isPlaying = filePath == state.filePath;

                    return ListTile(
                      title: Text(
                        fileName,
                        style: TextStyle(
                          fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      leading: Icon(
                        isPlaying ? Icons.music_note : Icons.audio_file,
                        color: isPlaying ? Theme.of(context).primaryColor : null,
                      ),
                      onTap: () => context.read<AudioCubit>().playFile(filePath),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 