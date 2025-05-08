import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/category.dart';
import 'package:flutter_quizlet/providers/auth_provider.dart';
import 'package:flutter_quizlet/providers/home_provider.dart';
import 'package:flutter_quizlet/screens/course_details_screen.dart';
import 'package:flutter_quizlet/screens/search_course_screen.dart';
import 'package:flutter_quizlet/screens/your_library_screen.dart';
import 'package:flutter_quizlet/widgets/course_item.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).streamCourses();
  }

  // 'Science',
  //   'Arts and Humanities',
  //   'Maths',
  //   'Social sciences',
  //   'General',
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user;
    final homeProvider = Provider.of<HomeProvider>(context);
    final top5NewCoures = homeProvider.courses.take(5).toList();
    final languageCourses =
        homeProvider.courses
            .where((course) => course.category == 'Languages')
            .toList();
    final scienceCourses =
        homeProvider.courses
            .where((course) => course.category == 'Science')
            .toList();

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // 🔍 Search + Avatar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // 🔍 Search Box
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search flashcards...',
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => SearchCourseScreen(
                                      searchKeyword: value,
                                    ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 👤 Avatar + PopupMenu
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'profile') {
                        Navigator.pushNamed(context, '/profile');
                      } else if (value == 'logout') {
                        await authProvider.signOut();
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'profile',
                            child: Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 8),
                                Text('Profile'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout),
                                SizedBox(width: 8),
                                Text('Logout'),
                              ],
                            ),
                          ),
                        ],
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            currentUser?.photoURL != null
                                ? NetworkImage(currentUser!.photoURL!)
                                : const AssetImage(
                                      'assets/images/default_avatar.png',
                                    )
                                    as ImageProvider,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 📘 Title "Courses New"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Courses New',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SearchCourseScreen(searchKeyword: null),
                        ),
                      );
                    },
                    child: Text('VIEW ALL'),
                  ),
                ],
              ),
            ),
          ),
          // 🧠 List of Courses
          SliverToBoxAdapter(
            child: SizedBox(
              height: 250, // Chiều cao item (tuỳ chỉnh theo design của bạn)
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                itemCount: top5NewCoures.length,
                itemBuilder: (context, index) {
                  final course = top5NewCoures[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CourseDetailsScreen(course: course),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CourseItem(
                        course: course,
                      ), // Dùng custom widget bạn đã viết
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Languages',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SearchCourseScreen(searchKeyword: null),
                        ),
                      );
                    },
                    child: Text('VIEW ALL'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 250, // Chiều cao item (tuỳ chỉnh theo design của bạn)
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                itemCount: languageCourses.length,
                itemBuilder: (context, index) {
                  final course = languageCourses[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CourseDetailsScreen(course: course),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CourseItem(
                        course: course,
                      ), // Dùng custom widget bạn đã viết
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Science',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SearchCourseScreen(searchKeyword: null),
                        ),
                      );
                    },
                    child: Text('VIEW ALL'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 250, // Chiều cao item (tuỳ chỉnh theo design của bạn)
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                itemCount: scienceCourses.length,
                itemBuilder: (context, index) {
                  final course = scienceCourses[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CourseDetailsScreen(course: course),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CourseItem(
                        course: course,
                      ), // Dùng custom widget bạn đã viết
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    categories.map((category) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      SearchCourseScreen(searchKeyword: null),
                            ),
                          );
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blueAccent),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue[900],
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
