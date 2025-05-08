import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quizlet/firebase_options.dart';
import 'package:flutter_quizlet/providers/auth_provider.dart';
import 'package:flutter_quizlet/providers/course_provider.dart';
import 'package:flutter_quizlet/providers/create_course_provider.dart';
import 'package:flutter_quizlet/providers/edit_course_provider.dart';
import 'package:flutter_quizlet/providers/history_provider.dart';
import 'package:flutter_quizlet/providers/home_provider.dart';
import 'package:flutter_quizlet/providers/user_provider.dart';
import 'package:flutter_quizlet/providers/your_library_provider.dart';
import 'package:flutter_quizlet/screens/create_course_screen.dart';
import 'package:flutter_quizlet/screens/create_screen.dart';
import 'package:flutter_quizlet/screens/login_screen.dart';
import 'package:flutter_quizlet/screens/main_screen.dart';
import 'package:flutter_quizlet/screens/register_2_screen.dart';
import 'package:flutter_quizlet/screens/register_screen.dart';
import 'package:flutter_quizlet/screens/splash_screen%20.dart';
import 'package:flutter_quizlet/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => CreateCourseProvider()),
        ChangeNotifierProvider(create: (_) => EditCourseProvider()),
        ChangeNotifierProvider(create: (_) => YourLibraryProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quizlet',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/main': (context) => const MainScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/register2': (context) => const Register2Screen(),
          '/create': (context) => const CreateScreen(),
          '/create-course': (context) => const CreateCourseScreen(),
        },
      ),
    );
  }
}
