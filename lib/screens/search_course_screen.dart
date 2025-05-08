import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/category.dart';
import 'package:flutter_quizlet/providers/home_provider.dart';
import 'package:flutter_quizlet/screens/course_details_screen.dart';
import 'package:flutter_quizlet/widgets/course_item.dart';
import 'package:provider/provider.dart';

class SearchCourseScreen extends StatefulWidget {
  String? searchKeyword;
  String? category;
  SearchCourseScreen({super.key, this.searchKeyword, this.category});

  @override
  State<StatefulWidget> createState() => _SearchCourseScreenState();
}

class _SearchCourseScreenState extends State<SearchCourseScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  late TabController _tabController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).streamCourses();
    if (widget.searchKeyword != null) {
      _searchQuery = widget.searchKeyword!;
      _searchController.text = widget.searchKeyword!;
    }

    _tabController = TabController(length: categories.length + 1, vsync: this);

    if (widget.category != null && categories.contains(widget.category)) {
      final categoryIndex =
          categories.indexOf(widget.category!) + 1;
      _tabController.index = categoryIndex;
      _selectedCategory = widget.category;
    } else {
      _tabController.index = 0;
      _selectedCategory = null;
    }

    _tabController.addListener(() {
      setState(() {
        _selectedCategory =
            _tabController.index == 0
                ? null
                : categories[_tabController.index - 1];
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeProvider provider = Provider.of<HomeProvider>(context);

    final filteredList =
        provider.courses.where((course) {
          final matchesSearch = course.title.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
          final matchesCategory =
              _selectedCategory == null || course.category == _selectedCategory;
          return matchesSearch && matchesCategory;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Result'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Search bar
            TextField(
              controller: _searchController,
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
              child:
                  filteredList.isEmpty
                      ? Center(
                        child: Text(
                          'Course is empty',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final course = filteredList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          CourseDetailsScreen(course: course),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: CourseItem(
                                course: course,
                              ), // Dùng custom widget bạn đã viết
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
