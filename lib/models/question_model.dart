class QuestionModel {
  final String question;
  final String correctAnswer;
  final List<String> options;

  QuestionModel({
    required this.question,
    required this.correctAnswer,
    required this.options,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'],
      correctAnswer: map['correctAnswer'],
      options: List<String>.from(map['options']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'correctAnswer': correctAnswer,
      'options': options,
    };
  }
}