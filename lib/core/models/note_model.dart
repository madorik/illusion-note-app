class Note {
  final String? id;
  final String title;
  final String content;
  final String? emotion;
  final double? emotionScore;
  final List<String>? tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? userId;
  final bool isPrivate;
  final String? category;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.emotion,
    this.emotionScore,
    this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.userId,
    this.isPrivate = true,
    this.category,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      emotion: json['emotion'],
      emotionScore: json['emotionScore']?.toDouble(),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      userId: json['userId'],
      isPrivate: json['isPrivate'] ?? true,
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      if (emotion != null) 'emotion': emotion,
      if (emotionScore != null) 'emotionScore': emotionScore,
      if (tags != null) 'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (userId != null) 'userId': userId,
      'isPrivate': isPrivate,
      if (category != null) 'category': category,
    };
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? emotion,
    double? emotionScore,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    bool? isPrivate,
    String? category,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      emotion: emotion ?? this.emotion,
      emotionScore: emotionScore ?? this.emotionScore,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      isPrivate: isPrivate ?? this.isPrivate,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, emotion: $emotion, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Note && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 