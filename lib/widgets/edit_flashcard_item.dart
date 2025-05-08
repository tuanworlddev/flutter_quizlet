import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/flashcard_model.dart';
import 'package:flutter_quizlet/providers/edit_course_provider.dart';
import 'package:provider/provider.dart';

class EditFlashcardItem extends StatefulWidget {
  final FlashcardModel flashcard;
  final int index;

  const EditFlashcardItem({
    super.key,
    required this.flashcard,
    required this.index,
  });

  @override
  State<StatefulWidget> createState() => _EditFlashcardItemState();
}

class _EditFlashcardItemState extends State<EditFlashcardItem> {
  final _frontController = TextEditingController();
  final _backController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _frontController.text = widget.flashcard.front;
    _backController.text = widget.flashcard.back;
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<EditCourseProvider>(context, listen: false);
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _frontController,
              decoration: InputDecoration(
                labelText: 'Front',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
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