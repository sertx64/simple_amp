import 'package:audioplayers/audioplayers.dart';

class AudioState {
  final PlayerState playerState;
  final Duration? duration;
  final Duration? position;
  final String? filePath;
  final String? selectedDirectory;
  final List<String> audioFiles;

  AudioState({
    this.playerState = PlayerState.stopped,
    this.duration,
    this.position,
    this.filePath,
    this.selectedDirectory,
    this.audioFiles = const [],
  });

  AudioState copyWith({
    PlayerState? playerState,
    Duration? duration,
    Duration? position,
    String? filePath,
    String? selectedDirectory,
    List<String>? audioFiles,
  }) {
    return AudioState(
      playerState: playerState ?? this.playerState,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      filePath: filePath ?? this.filePath,
      selectedDirectory: selectedDirectory ?? this.selectedDirectory,
      audioFiles: audioFiles ?? this.audioFiles,
    );
  }
} 