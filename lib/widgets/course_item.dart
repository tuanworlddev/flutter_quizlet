import 'package:flutter/material.dart';
import 'package:flutter_quizlet/models/course_model.dart';
import 'package:flutter_quizlet/models/custom_user.dart';
import 'package:flutter_quizlet/providers/user_provider.dart';
import 'package:flutter_quizlet/screens/course_details_screen.dart';
import 'package:provider/provider.dart';

class CourseItem extends StatefulWidget {
  final CourseModel course;

  const CourseItem({super.key, required this.course});

  @override
  State<StatefulWidget> createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {
  CustomUser? _user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  void _fetchUser() async {
    final user = await Provider.of<UserProvider>(
      context,
      listen: false,
    ).getUserById(widget.course.userId);
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsScreen(course: widget.course),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.cyan, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.cyan.shade100,
        child: Container(
          width: double.infinity,
          height: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      widget.course.title,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      '${widget.course.flashcards.length} terms',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Category: ${widget.course.category}',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.course.description,
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                  ],
                ),
              ),
              if (_user != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 16,
                  children: [
                    if (_user!.photoURL != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(_user!.photoURL!),
                      ),
                    Text(
                      _user!.displayName,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
