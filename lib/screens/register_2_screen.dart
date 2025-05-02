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
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        imageSelected = File(pickedImage.path);
        isValid = true;
      });
    }
  }

  Future<void> signUp() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = args['email'] as String;
    final password = args['password'] as String;
    final displayName = args['displayName'] as String;

    setState(() {
      loading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
      photo: imageSelected!,
    );

    setState(() {
      loading = false;
    });

    if (authProvider.user != null) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to sign up')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Upload Avatar',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              CircleAvatar(
                radius: 120,
                backgroundColor: Colors.grey.shade300,
                backgroundImage:
                    imageSelected != null ? FileImage(imageSelected!) : null,
                child:
                    imageSelected == null
                        ? Icon(Icons.person, size: 120, color: Colors.white70)
                        : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectImage,
                child: Text('Select Image'),
              ),
              const SizedBox(height: 30),
              FilledButton(
                onPressed: isValid && !loading ? signUp : null,
                style: FilledButton.styleFrom(fixedSize: Size.fromHeight(50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (loading)
                      SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.0,
                        ),
                      ),
                    const SizedBox(width: 10),
                    Text('Sign Up'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
