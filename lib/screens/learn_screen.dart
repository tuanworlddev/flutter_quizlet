import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_quizlet/models/course_model.dart';
import 'package:flutter_quizlet/models/flashcard_model.dart';
import 'package:flutter_quizlet/screens/learn_summary_screen.dart';

class LearnScreen extends StatefulWidget {
  final CourseModel course;

  const LearnScreen({super.key, required this.course});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  late List<FlashcardModel> flashcards;
  int currentIndex = 0;
  int correctCount = 0;
  final Map<int, FlipCardController> _controllers = {};

  

  @override
  void initState() {
    super.initState();
    flashcards = widget.course.flashcards;

    for (int i = 0; i < flashcards.length; i++) {
      _controllers[i] = FlipCardController();
    }
  }

  void handleAnswer(bool isCorrect) {
  if (isCorrect) correctCount++;

  if (currentIndex < flashcards.length - 1) {
    setState(() => currentIndex++);
  } else {
    // 👉 Đã học xong, chuyển qua màn hình summary
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LearnSummaryScreen(
          total: flashcards.length,
          correct: correctCount,
        ),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / flashcards.length;
    final currentCard = flashcards[currentIndex];
    final controller = _controllers[currentIndex]!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Flashcard Learn'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
          ),
          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SizedBox(
              height: 300,
              width: double.infinity,
              child: FlipCard(
                controller: controller,
                rotateSide: RotateSide.left,
                axis: FlipAxis.vertical,
                onTapFlipping: true,
                animationDuration: const Duration(milliseconds: 150),
                frontWidget: _buildCard(currentCard.front, isBack: false),
                backWidget: _buildCard(currentCard.back, isBack: true),
              ),
            ),
          ),

          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  heroTag: 'wrong',
                  onPressed: () => handleAnswer(false),
                  backgroundColor: Colors.red.shade100,
                  child: const Icon(Icons.close, color: Colors.red),
                ),
                FloatingActionButton(
                  heroTag: 'correct',
                  onPressed: () => handleAnswer(true),
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(Icons.check, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String text, {required bool isBack}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isBack ? Colors.orange.shade700 : Colors.indigo.shade900,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}


