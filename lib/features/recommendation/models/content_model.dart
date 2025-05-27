import 'dart:convert';
import 'package:flutter/material.dart';

enum ContentType {
  music,
  meditation,
  quote,
  tip,
}

class RecommendedContent {
  final String id;
  final String title;
  final String description;
  final ContentType type;
  final String? imageUrl;
  final String? audioUrl;
  final String? videoUrl;
  final String? link;
  final List<String> emotions;
  final DateTime createdAt;

  RecommendedContent({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.imageUrl,
    this.audioUrl,
    this.videoUrl,
    this.link,
    required this.emotions,
    required this.createdAt,
  });

  // 썸네일 이미지 URL을 가져옵니다.
  String get thumbnailUrl {
    // 이미지가 있으면 이미지 URL 반환
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl!;
    }
    
    // 타입별 기본 이미지 URL 반환
    switch (type) {
      case ContentType.music:
        return 'assets/images/content/music_default.png';
      case ContentType.meditation:
        return 'assets/images/content/meditation_default.png';
      case ContentType.quote:
        return 'assets/images/content/quote_default.png';
      case ContentType.tip:
        return 'assets/images/content/tip_default.png';
    }
  }

  // 타입에 따른 아이콘 데이터를 반환합니다.
  IconData get typeIcon {
    switch (type) {
      case ContentType.music:
        return Icons.music_note;
      case ContentType.meditation:
        return Icons.self_improvement;
      case ContentType.quote:
        return Icons.format_quote;
      case ContentType.tip:
        return Icons.lightbulb_outline;
    }
  }

  // 타입에 따른 색상 데이터를 반환합니다.
  Color get typeColor {
    switch (type) {
      case ContentType.music:
        return const Color(0xFF6B73FF);
      case ContentType.meditation:
        return const Color(0xFF64B5F6);
      case ContentType.quote:
        return const Color(0xFFFFB74D);
      case ContentType.tip:
        return const Color(0xFF81C784);
    }
  }

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'videoUrl': videoUrl,
      'link': link,
      'emotions': emotions,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // JSON 역직렬화
  factory RecommendedContent.fromJson(Map<String, dynamic> json) {
    return RecommendedContent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: ContentType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ContentType.quote,
      ),
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl'],
      videoUrl: json['videoUrl'],
      link: json['link'],
      emotions: List<String>.from(json['emotions']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

// 감정별 색상 매핑
class EmotionColors {
  static Color getColorForEmotion(String emotion) {
    switch (emotion.toLowerCase()) {
      case '행복':
      case '기쁨':
      case '만족':
      case '설렘':
        return const Color(0xFF81C784); // 녹색
      case '슬픔':
      case '우울':
      case '무기력':
        return const Color(0xFF64B5F6); // 파란색
      case '불안':
      case '걱정':
      case '혼란':
        return const Color(0xFFBA68C8); // 보라색
      case '화남':
      case '불만':
      case '좌절':
      case '후회':
        return const Color(0xFFE57373); // 빨간색
      case '희망':
      case '안도':
        return const Color(0xFF4FC3F7); // 하늘색
      default:
        return const Color(0xFF9E9E9E); // 회색
    }
  }
} 