import 'package:flutter/material.dart';
import '../models/content_model.dart';

class ContentCard extends StatelessWidget {
  final RecommendedContent content;
  final VoidCallback? onTap;

  const ContentCard({
    super.key,
    required this.content,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일 이미지
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 배경 이미지
                    Container(
                      color: content.typeColor.withOpacity(0.1),
                      child: content.imageUrl != null && content.imageUrl!.startsWith('assets/')
                          ? Image.asset(
                              content.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    content.typeIcon,
                                    size: 40,
                                    color: content.typeColor,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Icon(
                                content.typeIcon,
                                size: 40,
                                color: content.typeColor,
                              ),
                            ),
                    ),
                    // 콘텐츠 타입 배지
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: content.typeColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              content.typeIcon,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getTypeLabel(content.type),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 콘텐츠 정보
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 제목
                    Flexible(
                      child: Text(
                        content.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 설명
                    Text(
                      content.description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF718096),
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // 감정 태그
                    if (content.emotions.isNotEmpty)
                      SizedBox(
                        height: 18,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) => const SizedBox(width: 4),
                          itemCount: content.emotions.length > 2 ? 2 : content.emotions.length,
                          itemBuilder: (context, index) {
                            final emotion = content.emotions[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: EmotionColors.getColorForEmotion(emotion).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                emotion,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: EmotionColors.getColorForEmotion(emotion),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeLabel(ContentType type) {
    switch (type) {
      case ContentType.music:
        return '음악';
      case ContentType.meditation:
        return '명상';
      case ContentType.quote:
        return '명언';
      case ContentType.tip:
        return '심리 팁';
    }
  }
} 