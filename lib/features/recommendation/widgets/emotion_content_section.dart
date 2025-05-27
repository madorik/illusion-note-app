import 'package:flutter/material.dart';
import '../models/content_model.dart';
import 'content_card.dart';

class EmotionContentSection extends StatelessWidget {
  final String emotion;
  final List<RecommendedContent> contents;
  final Function(RecommendedContent) onContentTap;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;

  const EmotionContentSection({
    super.key,
    required this.emotion,
    required this.contents,
    required this.onContentTap,
    this.showViewAll = true,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (contents.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: EmotionColors.getColorForEmotion(emotion),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$emotion을 위한 콘텐츠',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ],
              ),
              if (showViewAll && onViewAllTap != null)
                TextButton(
                  onPressed: onViewAllTap,
                  child: Row(
                    children: [
                      Text(
                        '더보기',
                        style: TextStyle(
                          fontSize: 14,
                          color: EmotionColors.getColorForEmotion(emotion),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: EmotionColors.getColorForEmotion(emotion),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        
        // 콘텐츠 목록
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: contents.length,
            itemBuilder: (context, index) {
              return ContentCard(
                content: contents[index],
                onTap: () => onContentTap(contents[index]),
                width: 220,
              );
            },
          ),
        ),
      ],
    );
  }
} 