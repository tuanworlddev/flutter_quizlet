import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_quizlet/models/question_model.dart';
import 'package:flutter_quizlet/models/test_model.dart';
import 'package:flutter_quizlet/models/test_result_model.dart';
import 'package:flutter_quizlet/services/test_result_service.dart';

class TestScreen extends StatefulWidget {
  final TestModel test;

  const TestScreen({super.key, required this.test});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _currentQuestionIndex = 0;
  Map<int, String?> _userAnswers = {};
  bool _isSubmitted = false;
  int _correctAnswers = 0;
  final TestResultService _testResultService = TestResultService();

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.test.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  Future<void> _submitTest() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }
    int correctAnswers = 0;
    for (int i = 0; i < widget.test.questions.length; i++) {
      if (_userAnswers[i] == widget.test.questions[i].correctAnswer) {
        correctAnswers++;
      }
    }
    final totalQuestions = widget.test.questions.length;
    final score = (correctAnswers / totalQuestions * 10).toStringAsFixed(1);
    final testResult = TestResultModel(
      id:
          '${user.uid}_${widget.test.id}_${DateTime.now().millisecondsSinceEpoch}',
      userId: user.uid,
      testId: widget.test.id,
      answers: _userAnswers,
      score: double.parse(score),
      completedAt: DateTime.now(),
    );
    try {
      await _testResultService.saveTestResult(testResult);
      setState(() {
        _isSubmitted = true;
        _correctAnswers = correctAnswers;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving test result: $e')));
      setState(() {
        _isSubmitted = true;
        _correctAnswers = correctAnswers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.test.questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.test.title),
        actions: [
          if (!_isSubmitted)
            TextButton(
              onPressed: _submitTest,
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 4,
                children: [const Text('Submit'), const Icon(Icons.done)],
              ),
            ),
        ],
      ),
      body:
          _isSubmitted
              ? _buildResultView()
              : _buildQuestionView(currentQuestion),
    );
  }

  Widget _buildQuestionView(QuestionModel question) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${_currentQuestionIndex + 1}/${widget.test.questions.length}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(question.question, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          ...question.options.map(
            (option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _userAnswers[_currentQuestionIndex],
              onChanged: (value) {
                setState(() {
                  _userAnswers[_currentQuestionIndex] = value;
                });
              },
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.grey.shade900,
                ),
                child: const Text('Back'),
                
              ),
              ElevatedButton(
                onPressed:
                    _currentQuestionIndex < widget.test.questions.length - 1
                        ? _nextQuestion
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    final totalQuestions = widget.test.questions.length;
    final score = (_correctAnswers / totalQuestions * 10).toStringAsFixed(1);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Result: $_correctAnswers/$totalQuestions correct answer',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('Score: $score/10', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          const Text(
            'Test details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.test.questions.length,
              itemBuilder: (context, index) {
                final question = widget.test.questions[index];
                final userAnswer = _userAnswers[index];
                final isCorrect = userAnswer == question.correctAnswer;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
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
            ),
          ),
        ],
      ),
    );
  }
}
