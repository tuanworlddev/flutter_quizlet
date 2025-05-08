import 'package:flutter/material.dart';
import 'package:flutter_quizlet/providers/your_library_provider.dart';
import 'package:flutter_quizlet/screens/your_flashcard_preview_screen.dart';
import 'package:provider/provider.dart';

final List<String> categories = [
  'Languages',
  'Science',
  'Arts and Humanities',
  'Maths',
  'Social sciences',
  'General',
];

class YourLibraryScreen extends StatefulWidget {
  const YourLibraryScreen({super.key});

  @override
  State<YourLibraryScreen> createState() => _YourLibraryScreenState();
}

class _YourLibraryScreenState extends State<YourLibraryScreen> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  late TabController _tabController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    Provider.of<YourLibraryProvider>(context, listen: false).feachYourCourse();
    _tabController = TabController(length: categories.length + 1, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedCategory = _tabController.index == 0 ? null : categories[_tabController.index - 1];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final YourLibraryProvider provider = Provider.of<YourLibraryProvider>(context);

    final filteredList = provider.courses.where((course) {
      final matchesSearch = course.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || course.category == _selectedCategory;
      return matchesSearch && matchesCategory;
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
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // 📑 TabBar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: [
                const Tab(text: 'All'),
                ...categories.map((category) => Tab(text: category)),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: filteredList.isEmpty ? Center(child: Text('Course is empty', style: TextStyle(color: Colors.grey),),) : ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final course = filteredList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(course.title),
                      subtitle: Text(
                        '${course.category} • ${course.flashcards.length} cards',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YourFlashcardPreviewScreen(course: course),
                          ),
                        );
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