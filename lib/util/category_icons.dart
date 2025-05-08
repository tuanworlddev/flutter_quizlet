import 'package:flutter/material.dart';

IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Languages':
      return Icons.language;
    case 'Science':
      return Icons.science;
    case 'Arts and Humanities':
      return Icons.palette;
    case 'Maths':
      return Icons.calculate;
    case 'Social sciences':
      return Icons.groups_2;
    case 'General':
      return Icons.school;
    default:
      return Icons.book;
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case 'Languages':
      return Colors.blue;
    case 'Science':
      return Colors.green;
    case 'Arts and Humanities':
      return Colors.purple;
    case 'Maths':
      return Colors.orange;
    case 'Social sciences':
      return Colors.teal;
    case 'General':
      return Colors.grey;
    default:
      return Colors.black38;
  }
}
