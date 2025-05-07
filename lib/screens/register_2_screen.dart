import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quizlet/providers/auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Register2Screen extends StatefulWidget {
  const Register2Screen({super.key});

  @override
  State<StatefulWidget> createState() => _Register2ScreenState();
}

class _Register2ScreenState extends State<Register2Screen> {
  File? imageSelected;
  bool isValid = false;
  bool loading = false;

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageSelected = File(pickedImage.path);
        isValid = true;
      });
    }
  }

  Future<void> signUp() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = args['email'] as String;
    final password = args['password'] as String;
    final displayName = args['displayName'] as String;

    setState(() => loading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
      photo: imageSelected!,
    );

    setState(() => loading = false);

    if (authProvider.user != null) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              'Upload Your Avatar',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Avatar
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                backgroundImage: imageSelected != null ? FileImage(imageSelected!) : null,
                child: imageSelected == null
                    ? Icon(Icons.person, size: 80, color: Colors.white70)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // Select image
            OutlinedButton.icon(
              onPressed: selectImage,
              icon: Icon(Icons.image_outlined),
              label: Text('Choose Image'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 40),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: isValid && !loading ? signUp : null,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: loading
                    ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : const Text('Sign Up'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
