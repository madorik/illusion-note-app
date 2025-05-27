import 'package:flutter/material.dart';
import '../models/content_model.dart';

class ContentDetailScreen extends StatelessWidget {
  final RecommendedContent content;

  const ContentDetailScreen({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getContentTypeText(content.type),
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2D3748),
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            color: const Color(0xFF6B73FF),
            onPressed: () {
              // 공유 기능
              _showShareSuccessSnackBar(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            color: const Color(0xFF6B73FF),
            onPressed: () {
              // 저장 기능
              _showBookmarkSuccessSnackBar(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 콘텐츠 이미지
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                content.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: content.typeColor.withOpacity(0.2),
                    child: Center(
                      child: Icon(
                        content.typeIcon,
                        size: 48,
                        color: content.typeColor,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // 콘텐츠 정보
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 타입 배지
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: content.typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          content.typeIcon,
                          size: 16,
                          color: content.typeColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getContentTypeText(content.type),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: content.typeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 타이틀
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 감정 태그
                  if (content.emotions.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: content.emotions.map((emotion) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: EmotionColors.getColorForEmotion(emotion).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: EmotionColors.getColorForEmotion(emotion).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            emotion,
                            style: TextStyle(
                              fontSize: 14,
                              color: EmotionColors.getColorForEmotion(emotion),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  
                  const SizedBox(height: 20),
                  
                  // 설명
                  Text(
                    content.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4A5568),
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 콘텐츠 타입별 위젯 (오디오, 비디오, 링크 등)
                  _buildContentTypeWidget(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentTypeWidget(BuildContext context) {
    switch (content.type) {
      case ContentType.music:
      case ContentType.meditation:
        return _buildAudioPlayer();
      case ContentType.quote:
        return _buildQuoteCard();
      case ContentType.tip:
        return _buildTipCard();
    }
  }

  Widget _buildAudioPlayer() {
    // 실제 앱에서는 오디오 플레이어 위젯 구현
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: content.typeColor,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.grey[300],
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: content.typeColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '0:00',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // 재생 시작 버튼 로직
          },
          icon: const Icon(Icons.play_circle_filled),
          label: const Text('재생하기'),
          style: ElevatedButton.styleFrom(
            backgroundColor: content.typeColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: content.typeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: content.typeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.format_quote,
            size: 40,
            color: content.typeColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            content.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            content.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: content.typeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: content.typeColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: content.typeColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '심리학 팁',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: content.typeColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content.description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (content.link != null)
          OutlinedButton.icon(
            onPressed: () {
              // 링크 열기 로직
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('더 자세히 알아보기'),
            style: OutlinedButton.styleFrom(
              foregroundColor: content.typeColor,
              side: BorderSide(color: content.typeColor),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
      ],
    );
  }

  String _getContentTypeText(ContentType type) {
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

  void _showBookmarkSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('콘텐츠가 저장되었습니다.'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showShareSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('공유 링크가 복사되었습니다.'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
} 