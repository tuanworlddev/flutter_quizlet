import 'package:flutter/material.dart';
import 'package:flutter_quizlet/providers/auth_provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _displayNameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final name = _displayNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    final valid =
        name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        password.length >= 6 &&
        emailRegex.hasMatch(email);

    if (isValid != valid) {
      setState(() {
        isValid = valid;
      });
    }
  }

  Future<void> nextRegisterScreen() async {
    Navigator.pushNamed(
      context,
      '/register2',
      arguments: {
        'displayName': _displayNameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
      },
    );
  }

  Future<void> signIntWithGoogle() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signInWithGoogle();

    if (authProvider.user != null) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign Up',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _displayNameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter display name',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Enter email address',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password),
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: isValid ? nextRegisterScreen : null,
                style: FilledButton.styleFrom(fixedSize: Size.fromHeight(50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue'),
                    const SizedBox(width: 10),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Or', style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text('Sign in'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: signIntWithGoogle,
                style: OutlinedButton.styleFrom(fixedSize: Size.fromHeight(50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/google.svg'),
                    const SizedBox(width: 10),
                    Text('Sign in with Google'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
