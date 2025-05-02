import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 2), () {
        return FirebaseAuth.instance.currentUser;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          Future.microtask(() => Navigator.pushReplacementNamed(context, '/main'));
        } else {
          Future.microtask(() => Navigator.pushReplacementNamed(context, '/welcome'));
        }

        return const SizedBox();
      },
    );
  }
}
