import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/audio_state.dart';
import '../utils/permission_handler.dart';

class AudioCubit extends Cubit<AudioState> {
  final AudioPlayer _player;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  AudioCubit() : _player = AudioPlayer(), super(AudioState()) {
    _initPlayer();
  }

  void _initPlayer() {
    _player.setReleaseMode(ReleaseMode.stop);

    _durationSubscription = _player.onDurationChanged.listen((duration) {
      emit(state.copyWith(duration: duration));
    });

    _positionSubscription = _player.onPositionChanged.listen((position) {
      emit(state.copyWith(position: position));
    });

    _playerCompleteSubscription = _player.onPlayerComplete.listen((_) {
      _playNextFile();
    });

    _playerStateChangeSubscription = _player.onPlayerStateChanged.listen((playerState) {
      emit(state.copyWith(playerState: playerState));
    });
  }

  Future<void> _playNextFile() async {
    if (state.audioFiles.isEmpty) return;

    final currentIndex = state.audioFiles.indexOf(state.filePath ?? '');
    if (currentIndex == -1) return;

    final nextIndex = (currentIndex + 1) % state.audioFiles.length;
    final nextFile = state.audioFiles[nextIndex];

    await playFile(nextFile);
  }

  Future<void> playPreviousFile() async {
    if (state.audioFiles.isEmpty) return;

    final currentIndex = state.audioFiles.indexOf(state.filePath ?? '');
    if (currentIndex == -1) return;

    final previousIndex = (currentIndex - 1 + state.audioFiles.length) % state.audioFiles.length;
    final previousFile = state.audioFiles[previousIndex];

    await playFile(previousFile);
  }

  Future<void> playNextFile() async {
    await _playNextFile();
  }

  Future<void> pickDirectory() async {
    if (!await PermissionUtil.requestStoragePermission()) return;
    
    final selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) return;
    
    final directory = Directory(selectedDirectory);
    final audioFiles = <String>[];
    
    await for (final entity in directory.list()) {
      if (entity is File && _isAudioFile(entity.path)) {
        audioFiles.add(entity.path);
      }
    }
    
    if (audioFiles.isNotEmpty) {
      emit(state.copyWith(
        selectedDirectory: selectedDirectory,
        audioFiles: audioFiles,
      ));
    }
  }

  bool _isAudioFile(String path) {
    final audioExtensions = ['.mp3', '.wav', '.aac', '.m4a', '.ogg', '.flac'];
    return audioExtensions.any((ext) => path.toLowerCase().endsWith(ext));
  }

  Future<void> playFile(String filePath) async {
    emit(state.copyWith(filePath: filePath));
    await _player.setSource(DeviceFileSource(filePath));
    await _player.resume();
  }

  Future<void> play() async {
    await _player.resume();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
    emit(state.copyWith(
      playerState: PlayerState.stopped,
      position: Duration.zero,
    ));
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> close() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    _player.dispose();
    return super.close();
  }
} 