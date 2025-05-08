import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/flashcard_model.dart';
import 'package:flutter_quizlet/providers/create_course_provider.dart';
import 'package:flutter_quizlet/widgets/flashcard_item.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateFlashcardScreen extends StatefulWidget {
  final String titleCourse;
  final String categoryCourse;
  final String descripitonCourse;

  const CreateFlashcardScreen({
    super.key,
    required this.titleCourse,
    required this.categoryCourse,
    required this.descripitonCourse,
  });

  @override
  State<StatefulWidget> createState() => _CreateFlashcardScreenState();
}

class _CreateFlashcardScreenState extends State<CreateFlashcardScreen> {
  bool _isUploading = false;
  final Uuid _uuid = Uuid();

  Future<void> _createFlashcard() async {
    try {
      setState(() {
        _isUploading = true;
      });
      await Provider.of<CreateCourseProvider>(
        context,
        listen: false,
      ).createCourse(
        _uuid.v4(),
        widget.titleCourse,
        widget.categoryCourse,
        widget.descripitonCourse,
      );
      setState(() {
        _isUploading = false;
      });
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Create flashcard failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CreateCourseProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Create Flashcard'), centerTitle: true),
      body: Column(
        spacing: 16,
        children: [
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                courseProvider.reorderFlashcards(oldIndex, newIndex);
              },
              children:
                  courseProvider.flashcards
                      .asMap()
                      .entries
                      .map(
                        (entry) => FlashcardItem(
                          key: ValueKey(entry.value.id),
                          index: entry.key,
                          flashcard: entry.value,
                        ),
                      )
                      .toList(),
            ),
          ),
          OutlinedButton(
            onPressed:
                () =>
                    _isUploading
                        ? null
                        : courseProvider.addFlashCard(
                          FlashcardModel(
                            id: _uuid.v4(),
                            front: '',
                            back: '',
                            order: courseProvider.flashcards.length,
                          ),
                        ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add Flashcard'),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => _isUploading ? null : _createFlashcard(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isUploading)
                  CircularProgressIndicator(),
                Text('Finis'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
