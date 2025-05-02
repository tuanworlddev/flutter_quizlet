import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen ({ super.key });

  @override
  State<StatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(child: Text('History'),),
    );
  }
}