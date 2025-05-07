import 'package:flutter/material.dart';
import 'package:flutter_quizlet/util/category_icons.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<Map<String, dynamic>> _historyItems = [
    {
      'title': 'Flutter Basics',
      'category': 'code',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'completed': 12,
      'total': 15,
    },
    {
      'title': 'Basic Physics',
      'category': 'science',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'completed': 10,
      'total': 10,
    },
    {
      'title': 'Math Practice',
      'category': 'math',
      'date': DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      'completed': 5,
      'total': 12,
    },
  ];

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy – hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _historyItems.isEmpty
            ? Center(child: Text('No history yet.'))
            : ListView.builder(
                itemCount: _historyItems.length,
                itemBuilder: (context, index) {
                  final item = _historyItems[index];
                  final progress =
                      (item['completed'] / item['total']).clamp(0.0, 1.0);

                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.cyan[50],
                                child: Icon(getCategoryIcon(item['category']), color: Colors.cyan),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(item['title'],
                                    style: Theme.of(context).textTheme.titleMedium),
                              ),
                              Text('${item['completed']}/${item['total']}',
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[200],
                            color: Colors.cyan,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Studied on ${formatDateTime(item['date'])}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
