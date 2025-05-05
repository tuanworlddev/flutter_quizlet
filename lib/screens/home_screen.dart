import 'package:flutter/material.dart';
import 'package:flutter_quizlet/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _flashcardCourses = [
    {
      'title': 'English Vocabulary',
      'description': 'Basic English words for daily use.',
      'cardCount': 20,
      'icon': Icons.language,
    },
    {
      'title': 'Flutter Widgets',
      'description': 'Learn core Flutter components.',
      'cardCount': 15,
      'icon': Icons.flutter_dash,
    },
    {
      'title': 'Science Facts',
      'description': 'Cool facts for quiz practice.',
      'cardCount': 10,
      'icon': Icons.science_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                        )
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [Icon(Icons.person), SizedBox(width: 8), Text('Profile')],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [Icon(Icons.logout), SizedBox(width: 8), Text('Logout')],
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
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: currentUser?.photoURL != null
                          ? NetworkImage(currentUser!.photoURL!)
                          : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text(
              'Your Flashcard Courses',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // 🧠 List of courses
            Expanded(
              child: ListView.builder(
                itemCount: _flashcardCourses.length,
                itemBuilder: (context, index) {
                  final course = _flashcardCourses[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      leading: CircleAvatar(
                        backgroundColor: Colors.cyan[100],
                        child: Icon(course['icon'], color: Colors.cyan[800]),
                      ),
                      title: Text(course['title']),
                      subtitle: Text('${course['cardCount']} cards\n${course['description']}'),
                      isThreeLine: true,
                      trailing: Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        // Navigate to course detail
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
