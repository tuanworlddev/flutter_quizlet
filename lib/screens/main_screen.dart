import 'package:flutter/material.dart';
import 'package:flutter_quizlet/screens/create_course_screen.dart';
import 'package:flutter_quizlet/screens/create_screen.dart';
import 'package:flutter_quizlet/screens/history_screen.dart';
import 'package:flutter_quizlet/screens/home_screen.dart';
import 'package:flutter_quizlet/screens/your_library_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screenOptions = [
    const HomeScreen(),
    const CreateScreen(),
    const YourLibraryScreen(),
    const HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Cho phép nội dung tràn ra dưới BottomNavigationBar
      body: _screenOptions[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.cyan[700],
              unselectedItemColor: Colors.grey[400],
              showUnselectedLabels: false,
              showSelectedLabels: false,
              elevation: 0,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  label: 'Create',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.folder_outlined),
                  label: 'Library',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_outlined),
                  label: 'History',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
