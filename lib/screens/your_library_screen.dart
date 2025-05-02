import 'package:flutter/material.dart';

class YourLibraryScreen extends StatefulWidget {
  const YourLibraryScreen({ super.key });

  @override
  State<StatefulWidget> createState() => _YourLibraryScreenState();
}

class _YourLibraryScreenState extends State<YourLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(child: Text('Your Library'),),
    );
  }
}