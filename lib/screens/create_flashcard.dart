import 'package:flutter/material.dart';

class CreateFlashcard extends StatefulWidget {
  const CreateFlashcard({ super.key });

  @override
  State<StatefulWidget> createState() => _CreateFlashcardState();
}

class _CreateFlashcardState extends State<CreateFlashcard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(child: Text('Create Flash Card'),),
    );
  }
}