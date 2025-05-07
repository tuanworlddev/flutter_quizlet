import 'package:flutter/material.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create-course');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Create Flastcard')),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Expanded(child: Text('Create Test')),
                    Icon(Icons.arrow_forward_ios_rounded),
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
