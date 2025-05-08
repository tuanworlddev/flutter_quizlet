import 'package:flutter/material.dart';
import 'package:flutter_quizlet/providers/course_provider.dart';
import 'package:flutter_quizlet/providers/history_provider.dart';
import 'package:flutter_quizlet/widgets/course_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<HistoryProvider>(context, listen: false).streamHistories();
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy – hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('History Courses'), centerTitle: true),
      body:
          historyProvider.histories.isEmpty
              ? Center(child: Text('History is empty'))
              : ListView.builder(
                itemCount: historyProvider.histories.length,
                itemBuilder: (context, index) {
                  final history = historyProvider.histories[index];

                  return FutureBuilder(
                    future: courseProvider.getCourseById(history.courseId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const SizedBox.shrink();
                      }
                      final course = snapshot.data!;
                      return Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Riviewed: ${formatDateTime(history.viewedAt)}',
                              textAlign: TextAlign.end,
                            ),
                            CourseItem(course: course),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
