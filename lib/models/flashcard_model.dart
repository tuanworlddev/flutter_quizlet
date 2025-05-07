class FlashcardModel {
  final String id;
  final String front;
  final String back;
  final int order;
  final String? imageUrl;
  final String? audioUrl;

  FlashcardModel({
    required this.id,
    required this.front,
    required this.back,
    required this.order,
    this.imageUrl,
    this.audioUrl,
  });

  factory FlashcardModel.fromMap(Map<String, dynamic> map) {
    return FlashcardModel(
      id: map['id'],
      front: map['front'],
      back: map['back'],
      order: map['order'],
      imageUrl: map['imageUrl'],
      audioUrl: map['audioUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'front': front,
      'back': back,
      'order': order,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
    };
  }

  FlashcardModel copyWith({
    String? front,
    String? back,
    String? imageUrl,
    String? audioUrl,
    int? order,
  }) {
    return FlashcardModel(
      id: id,
      front: front ?? this.front,
      back: back ?? this.back,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      order: order ?? this.order,
    );
  }
}
