class EmotionAnalysis {
  final String id;
  final String originalText;
  final double emotionScore; // 0.0 (매우 부정적) ~ 1.0 (매우 긍정적)
  final List<String> cognitiveDistortions;
  final List<String> alternativeThoughts;
  final List<String> recommendations;
  final List<String> managementTips;
  final DateTime createdAt;

  EmotionAnalysis({
    required this.id,
    required this.originalText,
    required this.emotionScore,
    required this.cognitiveDistortions,
    required this.alternativeThoughts,
    required this.recommendations,
    required this.managementTips,
    required this.createdAt,
  });

  // JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalText': originalText,
      'emotionScore': emotionScore,
      'cognitiveDistortions': cognitiveDistortions,
      'alternativeThoughts': alternativeThoughts,
      'recommendations': recommendations,
      'managementTips': managementTips,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EmotionAnalysis.fromJson(Map<String, dynamic> json) {
    return EmotionAnalysis(
      id: json['id'],
      originalText: json['originalText'],
      emotionScore: json['emotionScore']?.toDouble() ?? 0.0,
      cognitiveDistortions: List<String>.from(json['cognitiveDistortions'] ?? []),
      alternativeThoughts: List<String>.from(json['alternativeThoughts'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      managementTips: List<String>.from(json['managementTips'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // 감정 상태 문자열 반환
  String get emotionState {
    if (emotionScore >= 0.7) {
      return '긍정적';
    } else if (emotionScore >= 0.4) {
      return '중립적';
    } else {
      return '부정적';
    }
  }

  // 감정 상태 색상
  EmotionColor get emotionColor {
    if (emotionScore >= 0.7) {
      return EmotionColor.positive;
    } else if (emotionScore >= 0.4) {
      return EmotionColor.neutral;
    } else {
      return EmotionColor.negative;
    }
  }

  // 복사본 생성
  EmotionAnalysis copyWith({
    String? id,
    String? originalText,
    double? emotionScore,
    List<String>? cognitiveDistortions,
    List<String>? alternativeThoughts,
    List<String>? recommendations,
    List<String>? managementTips,
    DateTime? createdAt,
  }) {
    return EmotionAnalysis(
      id: id ?? this.id,
      originalText: originalText ?? this.originalText,
      emotionScore: emotionScore ?? this.emotionScore,
      cognitiveDistortions: cognitiveDistortions ?? this.cognitiveDistortions,
      alternativeThoughts: alternativeThoughts ?? this.alternativeThoughts,
      recommendations: recommendations ?? this.recommendations,
      managementTips: managementTips ?? this.managementTips,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum EmotionColor {
  positive,
  neutral,
  negative,
} 