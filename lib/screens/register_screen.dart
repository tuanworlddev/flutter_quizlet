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

    final valid = name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        password.length >= 6 &&
        emailRegex.hasMatch(email);

    if (isValid != valid) {
      setState(() => isValid = valid);
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
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            SvgPicture.asset('assets/images/google.svg', height: 64),
            const SizedBox(height: 16),
            Text(
              'Create Your Account',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Name
            TextField(
              controller: _displayNameController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Display name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            // Email
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Email address',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            // Password
            TextField(
              controller: _passwordController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: isValid ? nextRegisterScreen : null,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Continue'),
                    SizedBox(width: 10),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text('Or', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 16),

            // Google Sign-In
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: signIntWithGoogle,
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/google.svg', height: 20),
                    const SizedBox(width: 10),
                    const Text('Sign in with Google'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Already have an account?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?", style: TextStyle(color: Colors.grey[700])),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Sign in'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
