// Step 1: Info Screen
import 'package:flutter/material.dart';
import 'package:flutter_quizlet/util/category_icons.dart'; // Import file category_icons.dart

class CreateFlashcardInfoScreen extends StatefulWidget {
  const CreateFlashcardInfoScreen({super.key});

  @override
  State<CreateFlashcardInfoScreen> createState() => _CreateFlashcardInfoScreenState();
}

class _CreateFlashcardInfoScreenState extends State<CreateFlashcardInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _setNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cardCountController = TextEditingController(text: '4');

  // Danh sách categories
  final List<String> _categories = ['Language', 'Code', 'Science', 'Math', 'General'];
  String? _selectedCategory;

  void _continue() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CreateFlashcardContentScreen(
            setName: _setNameController.text.trim(),
            description: _descriptionController.text.trim(),
            cardCount: int.tryParse(_cardCountController.text.trim()) ?? 5,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(Icons.note_add, size: 60, color: Colors.blueAccent),
              const SizedBox(height: 24),
              TextFormField(
                controller: _setNameController,
                decoration: InputDecoration(
                  labelText: 'Set Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),

              // Dropdown for Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Row(
                      children: [
                        Icon(getCategoryIcon(category), color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(getCategoryName(category)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _cardCountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of Cards',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  final num = int.tryParse(val ?? '');
                  if (num == null || num <= 0) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _continue,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Step 2: Flashcard Content Screen
class CreateFlashcardContentScreen extends StatefulWidget {
  final String setName;
  final String description;
  final int cardCount;

  const CreateFlashcardContentScreen({
    super.key,
    required this.setName,
    required this.description,
    required this.cardCount,
  });

  @override
  State<CreateFlashcardContentScreen> createState() => _CreateFlashcardContentScreenState();
}

class _CreateFlashcardContentScreenState extends State<CreateFlashcardContentScreen> {
  late List<Map<String, TextEditingController>> _cards;

  @override
  void initState() {
    super.initState();
    _cards = List.generate(widget.cardCount, (index) {
      return {
        'term': TextEditingController(),
        'definition': TextEditingController(),
      };
    });
  }

  void _save() {
    final flashcards = _cards.map((e) => {
      'term': e['term']!.text.trim(),
      'definition': e['definition']!.text.trim(),
    }).where((e) => e['term']!.isNotEmpty && e['definition']!.isNotEmpty).toList();

    if (flashcards.length < widget.cardCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all cards before saving.')),
      );
      return;
    }

    // TODO: Save to Firestore or your DB
    print('Set Name: ${widget.setName}');
    print('Description: ${widget.description}');
    print('Flashcards: $flashcards');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Flashcard set saved successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Flashcards')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(widget.setName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ..._cards.asMap().entries.map((entry) {
              final index = entry.key;
              final card = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Flashcard ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: card['term'],
                        decoration: InputDecoration(
                          labelText: 'Term',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: card['definition'],
                        decoration: InputDecoration(
                          labelText: 'Definition',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _save,
                child: const Text('Save Flashcard Set'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}