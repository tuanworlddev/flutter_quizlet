import 'package:flutter_quizlet/models/review_status.dart';

class FlashcardModel {
  final String id;
  final String front;
  final String back;
  final int order;
  final bool isFavorite;
  final ReviewStatus reviewStatus;
  final DateTime createdAt;
  final DateTime? lastReviewedAt;
  final String? imageUrl;
  final String? recordUrl;

  FlashcardModel({
    required this.id,
    required this.front,
    required this.back,
    required this.order,
    required this.isFavorite,
    required this.reviewStatus,
    required this.createdAt,
    this.lastReviewedAt,
    this.imageUrl,
    this.recordUrl,
  });

  factory FlashcardModel.fromMap(Map<String, dynamic> map) {
    return FlashcardModel(
      id: map['id'],
      front: map['front'],
      back: map['back'],
      order: map['order'],
      isFavorite: map['isFavorite'] ?? false,
      reviewStatus: ReviewStatus.values.firstWhere((e) => e.name == map['reviewStatus'], orElse: () => ReviewStatus.newCard),
      createdAt: DateTime.parse(map['createdAt']),
      lastReviewedAt: map['lastReviewedAt'] != null
          ? DateTime.parse(map['lastReviewedAt'])
          : null,
      imageUrl: map['imageUrl'],
      recordUrl: map['recordUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'front': front,
      'back': back,
      'order': order,
      'isFavorite': isFavorite,
      'reviewStatus': reviewStatus.name,
      'createdAt': createdAt.toIso8601String(),
      'lastReviewedAt': lastReviewedAt?.toIso8601String(),
      'imageUrl': imageUrl,
      'recordUrl': recordUrl,
    };
  }
}
