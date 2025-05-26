class EmotionAnalysisRequest {
  final String text;
  final String? moodId;
  final String mode;
  final String responseType;
  final String? context;

  EmotionAnalysisRequest({
    required this.text,
    this.moodId,
    this.mode = 'chat',
    this.responseType = 'comfort',
    this.context,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'mood_id': moodId ?? '',
      'mode': mode,
      'response_type': responseType,
      'context': context ?? '',
    };
  }
}

class EmotionAnalysisResponse {
  final String emotion;
  final String response;
  final String analyzeText;
  final String summary;
  final String title;

  EmotionAnalysisResponse({
    required this.emotion,
    required this.response,
    required this.analyzeText,
    required this.summary,
    required this.title,
  });

  factory EmotionAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return EmotionAnalysisResponse(
      emotion: json['emotion'] ?? '',
      response: json['response'] ?? '',
      analyzeText: json['analyze_text'] ?? '',
      summary: json['summary'] ?? '',
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emotion': emotion,
      'response': response,
      'analyze_text': analyzeText,
      'summary': summary,
      'title': title,
    };
  }

  @override
  String toString() {
    return 'EmotionAnalysisResponse(emotion: $emotion, title: $title)';
  }
}

class EmotionPost {
  final String id;
  final String userId;
  final String text;
  final String emotion;
  final String response;
  final String title;
  final DateTime createdAt;
  final String? analyzeText;
  final String? summary;
  final String? responseType;
  final Map<String, dynamic>? metadata;

  EmotionPost({
    required this.id,
    required this.userId,
    required this.text,
    required this.emotion,
    required this.response,
    required this.title,
    required this.createdAt,
    this.analyzeText,
    this.summary,
    this.responseType,
    this.metadata,
  });

  factory EmotionPost.fromJson(Map<String, dynamic> json) {
    DateTime parseCreatedAt() {
      if (json['created_at'] != null) {
        try {
          final timeString = json['created_at'].toString();
          // print('EmotionPost.fromJson - Original time string: $timeString'); // 디버깅용
          
          // 서버에서 받아온 시간을 파싱
          DateTime parsedTime = DateTime.parse(timeString);
          
          // 시간 문자열에 타임존 정보가 없다면 UTC로 간주
          if (!timeString.contains('Z') && !timeString.contains('+') && !timeString.contains('-', 10)) {
            // 타임존 정보가 없는 경우 UTC로 처리
            parsedTime = DateTime.utc(
              parsedTime.year,
              parsedTime.month,
              parsedTime.day,
              parsedTime.hour,
              parsedTime.minute,
              parsedTime.second,
              parsedTime.millisecond,
            );
          } else if (!parsedTime.isUtc) {
            // 이미 파싱된 시간이 UTC가 아니라면 UTC로 변환
            parsedTime = parsedTime.toUtc();
          }
          
          // print('EmotionPost.fromJson - Parsed as UTC: $parsedTime'); // 디버깅용
          return parsedTime;
        } catch (e) {
          // print('EmotionPost.fromJson - Parse error: $e'); // 디버깅용
          return DateTime.now().toUtc();
        }
      }
      return DateTime.now().toUtc();
    }

    return EmotionPost(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      text: json['text'] ?? '',
      emotion: json['emotion'] ?? '',
      response: json['response'] ?? '',
      title: json['title'] ?? '',
      createdAt: parseCreatedAt(),
      analyzeText: json['analyze_text'],
      summary: json['summary'],
      responseType: json['response_type'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'text': text,
      'emotion': emotion,
      'response': response,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'analyze_text': analyzeText,
      'summary': summary,
      'response_type': responseType,
      'metadata': metadata,
    };
  }

  @override
  String toString() {
    return 'EmotionPost(id: $id, emotion: $emotion, title: $title)';
  }
}

class RecentEmotionResponse {
  final String userId;
  final int count;
  final List<EmotionPost> posts;

  RecentEmotionResponse({
    required this.userId,
    required this.count,
    required this.posts,
  });

  factory RecentEmotionResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> postsData = json['posts'] ?? [];
    return RecentEmotionResponse(
      userId: json['userId']?.toString() ?? '',
      count: json['count'] ?? 0,
      posts: postsData.map((post) => EmotionPost.fromJson(post)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'count': count,
      'posts': posts.map((post) => post.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'RecentEmotionResponse(userId: $userId, count: $count, posts: ${posts.length})';
  }
} 