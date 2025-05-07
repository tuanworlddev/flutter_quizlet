import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/flashcard_model.dart';
import 'package:flutter_quizlet/providers/create_course_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class FlashcardItem extends StatefulWidget {
  final FlashcardModel flashcard;
  final int index;

  const FlashcardItem({
    super.key,
    required this.flashcard,
    required this.index,
  });

  @override
  State<StatefulWidget> createState() => _FlashcardItemState();
}

class _FlashcardItemState extends State<FlashcardItem> {
  final _frontController = TextEditingController();
  final _backController = TextEditingController();
  File? _selectedImage;
  File? _selectedVoice;
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _frontController.text = widget.flashcard.front;
    _backController.text = widget.flashcard.back;
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();
    // Listen to audio player state changes
    _audioPlayer?.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });
    // Listen to position changes
    _audioPlayer?.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });
    // Listen to duration changes
    _audioPlayer?.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration ?? Duration.zero;
        });
      }
    });
    // Listen to processing state to handle audio completion
    _audioPlayer?.processingStateStream.listen((state) {
      if (state == ProcessingState.completed && mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
        _audioPlayer?.seek(Duration.zero);
        _audioPlayer?.pause();
      }
    });
  }

  void _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      Provider.of<CreateCourseProvider>(context, listen: false).changeFlashcard(widget.index, widget.flashcard.copyWith(imageUrl: image.path));
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.audio,
    );
    if (result != null) {
      Provider.of<CreateCourseProvider>(context, listen: false).changeFlashcard(
                  widget.index,
                  widget.flashcard.copyWith(audioUrl: result.files.single.path)
                );
      setState(() {
        _selectedVoice = File(result.files.single.path!);
        _initAudioPlay();
      });
    }
  }

  void _initAudioPlay() async {
    if (_selectedVoice != null) {
      await _audioPlayer?.setFilePath(_selectedVoice!.path);
    }
  }

  void _playAndPauseAudio() async {
    if (_audioPlayer != null) {
      if (_isPlaying) {
        await _audioPlayer!.pause();
      } else {
        await _audioPlayer!.play();
      }
    }
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CreateCourseProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.tonalIcon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image, size: 20),
                  label: const SizedBox.shrink(),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.keyboard_voice, size: 20),
                  label: const SizedBox.shrink(),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: () {},
                  icon: const Icon(Icons.remove_red_eye, size: 20),
                  label: const SizedBox.shrink(),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: () => courseProvider.removeFlashcard(widget.index),
                  icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent),
                  label: const SizedBox.shrink(),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_selectedImage != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                    height: 150,
                    width: double.infinity,
                  ),
                ),
              ),
            if (_selectedImage != null) const SizedBox(height: 12),
            if (_selectedVoice != null && _audioPlayer != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _playAndPauseAudio,
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: theme.colorScheme.primary,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: [
                          Slider(
                            value: _position.inSeconds.toDouble(),
                            max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0,
                            activeColor: theme.colorScheme.primary,
                            inactiveColor: theme.colorScheme.onSurface.withOpacity(0.3),
                            onChanged: (value) async {
                              await _audioPlayer?.seek(Duration(seconds: value.toInt()));
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}',
                                style: theme.textTheme.bodySmall,
                              ),
                              Text(
                                '${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (_selectedVoice != null) const SizedBox(height: 12),
            TextField(
              controller: _frontController,
              decoration: InputDecoration(
                labelText: 'Front',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              style: theme.textTheme.bodyMedium,
              onChanged: (value) {
                courseProvider.changeFlashcard(
                  widget.index,
                  widget.flashcard.copyWith(front: value)
                );
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _backController,
              decoration: InputDecoration(
                labelText: 'Back',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              style: theme.textTheme.bodyMedium,
              onChanged: (value) {
                courseProvider.changeFlashcard(
                  widget.index,
                  widget.flashcard.copyWith(back: value)
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}