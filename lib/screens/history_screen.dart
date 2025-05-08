import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Placeholder imports for your services and models
import 'package:flutter_quizlet/models/test_result_model.dart';
import 'package:flutter_quizlet/services/test_result_service.dart';
import 'package:flutter_quizlet/screens/test_result_detail_screen.dart';
import 'package:flutter_quizlet/providers/course_provider.dart';
import 'package:flutter_quizlet/providers/history_provider.dart';
import 'package:flutter_quizlet/widgets/course_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TestResultService _testResultService = TestResultService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Provider.of<HistoryProvider>(context, listen: false).streamHistories();
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy – hh:mm a').format(dateTime);
  }

  Widget buildCourseHistory(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);

    if (historyProvider.histories.isEmpty) {
      return const Center(child: Text('No course history'));
    }

    return ListView.builder(
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
                    'Reviewed: ${formatDateTime(history.viewedAt)}',
                    textAlign: TextAlign.end,
                  ),
                  CourseItem(course: course),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTestHistory() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('User not logged in'));
    }

    return StreamBuilder<List<TestResultModel>>(
      stream: _testResultService.streamTestResultsByUser(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No test history'));
        }
        final testResults = snapshot.data!;
        return ListView.builder(
          itemCount: testResults.length,
          itemBuilder: (context, index) {
            final result = testResults[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TestResultDetailScreen(result: result),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.cyan), borderRadius: BorderRadius.circular(12)),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test ID: ${result.testId}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('Score: ${result.score}/10\nCompleted at: ${formatDateTime(result.completedAt)}',),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Course History'), Tab(text: 'Test History')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [buildCourseHistory(context), buildTestHistory()],
      ),
    );
  }
}
