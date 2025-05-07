// Step 1: Info Screen
import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/category.dart';
import 'package:flutter_quizlet/screens/create_flashcard_screen.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;

  void _onChangedCategory(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => CreateFlashcardScreen(
                titleCourse: _titleController.text,
                categoryCourse: _selectedCategory!,
                descripitonCourse: _descriptionController.text,
              ),
        ),
      );
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
    return Scaffold(
      appBar: AppBar(title: Text('Create Course'), centerTitle: true),
      body: SingleChildScrollView(
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
                validator:
                    (value) => value!.isEmpty ? "Please enter a title" : null,
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
                        value == null || value.isEmpty ? "Please select a category" : null,
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
              FilledButton(
                onPressed: _continue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('Continue', textAlign: TextAlign.center),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded),
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
