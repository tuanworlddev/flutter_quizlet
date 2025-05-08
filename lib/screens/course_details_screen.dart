import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_quizlet/models/course_model.dart';
import 'package:flutter_quizlet/providers/history_provider.dart';
import 'package:provider/provider.dart';

class CourseDetailsScreen extends StatefulWidget {
  final CourseModel course;
  const CourseDetailsScreen({super.key, required this.course});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  late Map<int, FlipCardController> _flipControllers;

  @override
  void initState() {
    super.initState();
    Provider.of<HistoryProvider>(context, listen: false).createHistory(widget.course.id);
    _flipControllers = {
      for (int i = 0; i < widget.course.flashcards.length; i++)
        i: FlipCardController()
    };

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flashcards = widget.course.flashcards;
    final course = widget.course;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
        centerTitle: true,
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 260,
              child: PageView.builder(
                controller: _pageController,
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  final flashcard = flashcards[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: FlipCard(
                        onTapFlipping: true,
                      controller: _flipControllers[index]!,
                      rotateSide: RotateSide.left,
                      axis: FlipAxis.vertical,
                      animationDuration: const Duration(milliseconds: 300),
                      frontWidget: buildCardSide(flashcard.front),
                      backWidget: buildCardSide(flashcard.back),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),
            Center(
              child: Text(
                '${_currentPage + 1} / ${flashcards.length}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              course.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://avatar.iran.liara.run/public/24'),
                ),
                const SizedBox(width: 10),
                 Text('User Quizlet', style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                
              ],
            ),
            const SizedBox(height: 24),

            // 📄 Description
            const Text('Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              course.description.isNotEmpty
                  ? course.description
                  : 'No description provided.',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text('Learn'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade100,
                      foregroundColor: Colors.deepPurple.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.quiz_outlined),
                    label: const Text('Test'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCardSide(String content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.cyan,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

}
