import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quizlet/models/test_model.dart';
import 'package:flutter_quizlet/models/test_result_model.dart';

class TestResultDetailScreen extends StatelessWidget {
  final TestResultModel result;

  const TestResultDetailScreen({ super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Result: ${result.answers.length} questions, ${result.score}/10',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<TestModel?>(
                future: _getTestById(result.testId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('Test not found'));
                  }
                  final test = snapshot.data!;
                  return ListView.builder(
                    itemCount: test.questions.length,
                    itemBuilder: (context, index) {
                      final question = test.questions[index];
                      final userAnswer = result.answers[index];
                      final isCorrect = userAnswer == question.correctAnswer;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.cyan), borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(question.question),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Your answer: ${userAnswer ?? "Not selected"}'),
                              Text(
                                'Correct answer: ${question.correctAnswer}',
                                style: TextStyle(
                                  color: isCorrect ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          leading: Icon(
                            isCorrect ? Icons.check_circle : Icons.cancel,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<TestModel?> _getTestById(String testId) async {
    final doc = await FirebaseFirestore.instance.collection('tests').doc(testId).get();
    if (doc.exists) {
      return TestModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}