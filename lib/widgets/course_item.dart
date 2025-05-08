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
  State<CourseItem> createState() => _CourseItemState();
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
    if (mounted && user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final avatar = _user?.photoURL ??
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnCj60zcZPmoHzt4YFKnxfaSCAO_bwXNjskiDX_ahOHXoJnqL8B6MUtddnul2cMpyBoWM&usqp=CAU';
    final displayName =
        _user?.displayName.isNotEmpty == true ? _user!.displayName : 'User Quizlet';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsScreen(course: course),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.cyan, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.cyan.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📘 Title
              Text(
                course.title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // 📊 Term count + category
              Row(
                children: [
                  Text(
                    '${course.flashcards.length} terms',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    course.category,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 👤 User Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(avatar),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
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
