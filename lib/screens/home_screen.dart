import 'package:flutter/material.dart';
import 'package:flutter_quizlet/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.user;

    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Please Login'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(currentUser.displayName ?? 'No name'),
              accountEmail: Text(currentUser.email ?? 'No email'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(currentUser.photoURL ?? ''),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () async {
                await authProvider.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID: ${currentUser.uid}'),
            Text('Name: ${currentUser.displayName ?? ''}'),
            Text('Email: ${currentUser.email ?? ''}'),
          ],
        ),
      ),
    );
  }
}
