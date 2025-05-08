import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/category.dart';
import 'package:flutter_quizlet/models/course_model.dart';
import 'package:flutter_quizlet/models/flashcard_model.dart';
import 'package:flutter_quizlet/providers/edit_course_provider.dart';
import 'package:flutter_quizlet/widgets/edit_flashcard_item.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditCourseScreen extends StatefulWidget {
  final CourseModel course;
  const EditCourseScreen({super.key, required this.course});

  @override
  State<StatefulWidget> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<EditCourseProvider>(
      context,
      listen: false,
    ).setCourse(widget.course);
    _titleController.text = widget.course.title;
    _descriptionController.text = widget.course.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editCourseProvider = Provider.of<EditCourseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Course'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await Provider.of<EditCourseProvider>(
                  context,
                  listen: false,
                ).updateCourse();
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Row(children: [Icon(Icons.save), Text(' Save')]),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title course',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? "Please enter a title" : null,
                      onChanged: (value) {
                        value = value.trim();
                        if (value.isNotEmpty) {
                          editCourseProvider.changeCourse(
                            widget.course.copyWith(title: value),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField(
                      value: editCourseProvider.course.category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          categories
                              .map(
                                (category) => DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                ),
                              )
                              .toList(),
                      onChanged: (category) {
                        if (category != null) {
                          editCourseProvider.changeCourse(
                            widget.course.copyWith(category: category),
                          );
                        }
                      },
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Please select a category"
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      maxLines: 3,
                      minLines: 3,
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? "Please enter a description"
                                  : null,
                      onChanged: (value) {
                        value = value.trim();
                        if (value.isNotEmpty) {
                          editCourseProvider.changeCourse(
                            widget.course.copyWith(description: value),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Flashcards:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              SliverReorderableList(
                itemCount: editCourseProvider.course.flashcards.length,
                onReorder: (oldIndex, newIndex) {
                  editCourseProvider.reorderFlashcards(oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final flashcard = editCourseProvider.course.flashcards[index];
                  return EditFlashcardItem(
                    key: ValueKey(flashcard.id),
                    index: index,
                    flashcard: flashcard,
                  );
                },
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        editCourseProvider.addFlashCard(
                          FlashcardModel(
                            id: Uuid().v4(),
                            front: '',
                            back: '',
                            order: editCourseProvider.course.flashcards.length,
                          ),
                        );
                      },
                      child: Text('Add Flashcard'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
