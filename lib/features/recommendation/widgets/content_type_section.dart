import 'package:flutter/material.dart';
import '../models/content_model.dart';
import 'content_card.dart';

class ContentTypeSection extends StatelessWidget {
  final ContentType contentType;
  final List<RecommendedContent> contents;
  final Function(RecommendedContent) onContentTap;
  final bool showViewAll;
  final VoidCallback? onViewAllTap;

  const ContentTypeSection({
    super.key,
    required this.contentType,
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
    
    // 콘텐츠 타입에 따른 색상과 아이콘 가져오기
    final Color typeColor = contents.first.typeColor;
    final IconData typeIcon = contents.first.typeIcon;
    
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
                  Icon(
                    typeIcon,
                    color: typeColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getContentTypeTitle(contentType),
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
                          color: typeColor,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: typeColor,
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

  String _getContentTypeTitle(ContentType type) {
    switch (type) {
      case ContentType.music:
        return '힐링 음악';
      case ContentType.meditation:
        return '명상 오디오';
      case ContentType.quote:
        return '공감의 글귀';
      case ContentType.tip:
        return '심리학 팁';
    }
  }
} 