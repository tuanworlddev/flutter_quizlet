import 'package:flutter/material.dart';
import 'package:flutter_quizlet/providers/auth_provider.dart';
import 'package:flutter_quizlet/providers/home_provider.dart';
import 'package:flutter_quizlet/screens/course_details_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user;
    final homeProvider = Provider.of<HomeProvider>(context);

    return SafeArea(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Top bar
            Row(
              children: [
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
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search flashcards...',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
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

            const SizedBox(height: 24),
            Text('Courses', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),

            // 🧠 List of courses
            Expanded(
              child: ListView.builder(
                itemCount: homeProvider.course.length,
                itemBuilder: (context, index) {
                  final course = homeProvider.course[index];
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
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Card(
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              course.description,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
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
