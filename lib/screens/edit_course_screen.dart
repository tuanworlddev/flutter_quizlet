import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quizlet/models/category.dart';
import 'package:flutter_quizlet/models/course_model.dart';
import 'package:flutter_quizlet/models/flashcard_model.dart';
import 'package:flutter_quizlet/providers/edit_course_provider.dart';
import 'package:provider/provider.dart';

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
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    Provider.of<EditCourseProvider>(context).setCourse(widget.course);
    _titleController.text = widget.course.title;
    _descriptionController.text = widget.course.description;
    _selectedCategory = widget.course.category;
  }

  void _onChangedCategory(String? category) {
    if (category != null) {
      setState(() {
        _selectedCategory = category;
      });
    }
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
        title: Text('Edit Course'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.save), Text(' Save')],
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title course',
                  border: OutlineInputBorder(),
                ),
              ),
              DropdownButtonFormField(
                value: _selectedCategory,
                decoration: InputDecoration(
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
                onChanged: _onChangedCategory,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? "Please select a category"
                            : null,
              ),
              TextFormField(
                maxLines: 3,
                minLines: 3,
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? "Please enter a description" : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditFlashcard(FlashcardModel flashcard) {
    final _frontController = TextEditingController();
    final _backController = TextEditingController();

    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [TextField()],
        ),
      ),
    );
  }
}
