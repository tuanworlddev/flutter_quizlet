import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_quizlet/models/course_model.dart';
import 'package:flutter_quizlet/screens/edit_course_screen.dart';
import 'package:flutter_quizlet/services/course_service.dart';

class YourFlashcardPreviewScreen extends StatefulWidget {
  final CourseModel course;
  const YourFlashcardPreviewScreen({super.key, required this.course});

  @override
  State<StatefulWidget> createState() => _YourFlashcardPreviewScreenState();
}

class _YourFlashcardPreviewScreenState
    extends State<YourFlashcardPreviewScreen> {
  final _courseService = CourseService();
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  final Map<int, FlipCardController> _flipControllers = {};

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.course.flashcards.length; i++) {
      _flipControllers[i] = FlipCardController();
    }

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard Preview'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCourseScreen(course: widget.course),
                ),
              );
            },
            child: Row(children: [Text('Edit'), Icon(Icons.chevron_right)]),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.course.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${_currentPage + 1} / ${flashcards.length}',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 250,
              child: PageView.builder(
                controller: _pageController,
                itemCount: flashcards.length,
                itemBuilder: (context, index) {
                  final flashcard = flashcards[index];
                  final controller = _flipControllers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: FlipCard(
                      frontWidget: buildCardSide(
                        flashcard.front,
                        flashcard.imageUrl,
                        flashcard.audioUrl,
                      ),
                      backWidget: buildCardSide(flashcard.back, null, null),
                      controller: controller!,
                      rotateSide: RotateSide.left,
                      axis: FlipAxis.vertical,
                      onTapFlipping: true,
                      animationDuration: Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Category: ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.course.category,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.course.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 16),
                  FilledButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text(
                                'Are you sure you want to delete this course?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );

                      if (confirmed == true) {
                        await _courseService.deleteCourse(widget.course.id);
                        if (mounted) Navigator.pop(context);
                      }
                    },
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardSide(String content, String? imageUrl, String? audioUrl) {
    return SizedBox(
      height: 250,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.cyan,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
