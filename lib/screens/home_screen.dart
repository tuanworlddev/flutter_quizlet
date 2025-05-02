import 'package:flutter/material.dart';
import 'package:flutter_quizlet/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search',
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
                          children: [Text('Profile'), Icon(Icons.person)],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [Text('Logout'), Icon(Icons.logout)],
                        ),
                      ),
                    ],
                child: CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      currentUser?.photoURL != null
                          ? NetworkImage(currentUser!.photoURL!)
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
