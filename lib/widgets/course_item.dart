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
                      const SizedBox(width: 8),
                      Text(
                        course.category,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  if (_user != null)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage:
                              _user != null && _user!.photoURL != null
                                  ? NetworkImage(_user!.photoURL!)
                                  : const NetworkImage(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnCj60zcZPmoHzt4YFKnxfaSCAO_bwXNjskiDX_ahOHXoJnqL8B6MUtddnul2cMpyBoWM&usqp=CAU',
                                  ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _user!.displayName.isNotEmpty
                                ? _user!.displayName
                                : 'User Quizlet',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: const NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnCj60zcZPmoHzt4YFKnxfaSCAO_bwXNjskiDX_ahOHXoJnqL8B6MUtddnul2cMpyBoWM&usqp=CAU',
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'User Quizlet',
                            style: TextStyle(
                              fontSize: 18,
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
          ],
        ),
      ),
    );
  }
}
