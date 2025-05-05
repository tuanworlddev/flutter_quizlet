import 'package:flutter/material.dart';

IconData getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'language':
      return Icons.language;
    case 'code':
      return Icons.flutter_dash;
    case 'science':
      return Icons.science_outlined;
    case 'math':
      return Icons.calculate_outlined;
    default:
      return Icons.book_outlined; // fallback icon
  }
}

String getCategoryName(String category) {
  switch (category.toLowerCase()) {
    case 'language':
      return 'Language';
    case 'code':
      return 'Programming';
    case 'science':
      return 'Science';
    case 'math':
      return 'Mathematics';
    default:
      return 'General';
  }
}
