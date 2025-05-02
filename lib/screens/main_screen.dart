import 'package:flutter/material.dart';
import 'package:flutter_quizlet/screens/create_flashcard.dart';
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
    const CreateFlashcard(),
    const YourLibraryScreen(),
    const HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenOptions[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.cyan,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
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
    );
  }
}
