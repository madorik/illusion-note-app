class EmotionAnalysis {
  final String emotion;
  final double confidence;
  final Map<String, double>? emotionScores;
  final String? description;
  final List<String>? keywords;

  EmotionAnalysis({
    required this.emotion,
    required this.confidence,
    this.emotionScores,
    this.description,
    this.keywords,
  });

  factory EmotionAnalysis.fromJson(Map<String, dynamic> json) {
    return EmotionAnalysis(
      emotion: json['emotion'] ?? '',
      confidence: json['confidence']?.toDouble() ?? 0.0,
      emotionScores: json['emotionScores'] != null
          ? Map<String, double>.from(json['emotionScores'])
          : null,
      description: json['description'],
      keywords: json['keywords'] != null 
          ? List<String>.from(json['keywords']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emotion': emotion,
      'confidence': confidence,
      if (emotionScores != null) 'emotionScores': emotionScores,
      if (description != null) 'description': description,
      if (keywords != null) 'keywords': keywords,
    };
  }

  @override
  String toString() {
    return 'EmotionAnalysis(emotion: $emotion, confidence: $confidence)';
  }
}

class EmotionRequest {
  final String text;
  final String? language;

  EmotionRequest({
    required this.text,
    this.language = 'ko',
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      if (language != null) 'language': language,
    };
  }
} 