import 'package:flutter/material.dart';
import 'package:flutter_quizlet/util/category_icons.dart';

class YourLibraryScreen extends StatefulWidget {
  const YourLibraryScreen({super.key});

  @override
  State<YourLibraryScreen> createState() => _YourLibraryScreenState();
}

class _YourLibraryScreenState extends State<YourLibraryScreen> {
  final List<Map<String, dynamic>> _flashcardSets = [
    {
      'title': 'Basic English',
      'category': 'language',
      'cardCount': 20,
    },
    {
      'title': 'Algebra',
      'category': 'math',
      'cardCount': 15,
    },
    {
      'title': 'Flutter Widgets',
      'category': 'code',
      'cardCount': 12,
    },
    {
      'title': 'Physics Basics',
      'category': 'science',
      'cardCount': 18,
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredList = _flashcardSets.where((set) {
      return set['title']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search flashcards...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // 📋 List of sets
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final set = filteredList[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(getCategoryIcon(set['category']), color: Colors.blue),
                      ),
                      title: Text(set['title']),
                      subtitle: Text(
                          '${getCategoryName(set['category'])} • ${set['cardCount']} cards'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: Navigate to detail page
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
