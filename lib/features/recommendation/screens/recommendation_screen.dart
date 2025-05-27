import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/content_model.dart';
import '../providers/recommendation_provider.dart';
import '../widgets/content_card.dart';
import 'content_detail_screen.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecommendationProvider(),
      child: const _RecommendationView(),
    );
  }
}

class _RecommendationView extends StatefulWidget {
  const _RecommendationView();

  @override
  State<_RecommendationView> createState() => _RecommendationViewState();
}

class _RecommendationViewState extends State<_RecommendationView> {
  String? _selectedEmotion;
  ContentType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          '감정 맞춤 추천',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2D3748),
            size: 20,
          ),
          onPressed: () {
            context.goNamed('home');
          },
        ),
      ),
      body: Consumer<RecommendationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6B73FF),
              ),
            );
          }

          if (provider.error != null) {
            return _buildErrorState(provider.error!);
          }

          // 자주 느끼는 감정이 없거나 추천이 없는 경우
          if (provider.frequentEmotions.isEmpty || provider.recommendations.isEmpty) {
            return _buildEmptyState();
          }

          // 현재 선택된 감정에 따른 콘텐츠 필터링
          final filteredContents = _selectedEmotion != null 
              ? provider.getRecommendationsByEmotion(_selectedEmotion!)
              : provider.recommendations;

          // 콘텐츠 타입 필터 적용
          final displayContents = _selectedType != null
              ? filteredContents.where((content) => content.type == _selectedType).toList()
              : filteredContents;

          return Column(
            children: [
              // 감정 필터
              _buildEmotionFilter(provider.frequentEmotions),
              
              // 콘텐츠 타입 필터
              _buildContentTypeFilter(),
              
              // 콘텐츠 그리드
              Expanded(
                child: displayContents.isEmpty
                    ? _buildNoContentState()
                    : RefreshIndicator(
                        onRefresh: () async {
                          await provider.refreshData();
                        },
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                          itemCount: displayContents.length,
                          itemBuilder: (context, index) {
                            final content = displayContents[index];
                            return ContentCard(
                              content: content,
                              onTap: () => _navigateToContentDetail(context, content),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 필터 초기화
          setState(() {
            _selectedEmotion = null;
            _selectedType = null;
          });
        },
        backgroundColor: const Color(0xFF6B73FF),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildEmotionFilter(List<String> emotions) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '당신의 감정',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: emotions.length,
              itemBuilder: (context, index) {
                final emotion = emotions[index];
                final isSelected = emotion == _selectedEmotion;
                final color = EmotionColors.getColorForEmotion(emotion);
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedEmotion == emotion) {
                          _selectedEmotion = null;
                        } else {
                          _selectedEmotion = emotion;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? color : color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: color,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        emotion,
                        style: TextStyle(
                          color: isSelected ? Colors.white : color,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTypeFilter() {
    final types = ContentType.values;
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '콘텐츠 타입',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: types.length,
              itemBuilder: (context, index) {
                final type = types[index];
                final isSelected = type == _selectedType;
                
                String typeLabel;
                switch (type) {
                  case ContentType.music:
                    typeLabel = '음악';
                    break;
                  case ContentType.meditation:
                    typeLabel = '명상';
                    break;
                  case ContentType.quote:
                    typeLabel = '명언';
                    break;
                  case ContentType.tip:
                    typeLabel = '심리 팁';
                    break;
                }
                
                final dummyContent = RecommendedContent(
                  id: '',
                  title: '',
                  description: '',
                  type: type,
                  emotions: [],
                  createdAt: DateTime.now(),
                );
                
                final color = dummyContent.typeColor;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedType == type) {
                          _selectedType = null;
                        } else {
                          _selectedType = type;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? color : color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: color,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            dummyContent.typeIcon,
                            size: 16,
                            color: isSelected ? Colors.white : color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            typeLabel,
                            style: TextStyle(
                              color: isSelected ? Colors.white : color,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFE53E3E),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: const TextStyle(
              color: Color(0xFFE53E3E),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // 다시 시도 로직
              Provider.of<RecommendationProvider>(context, listen: false).refreshData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B73FF),
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoContentState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_outlined,
            color: Color(0xFF718096),
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            '검색 결과가 없습니다',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '다른 감정이나 콘텐츠 유형을 선택해보세요',
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_recommendation.png',
            height: 160,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          const Text(
            '아직 맞춤 추천을 준비하고 있어요',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              '감정 대화를 통해 더 많은 감정을 기록하면\n당신에게 맞는 콘텐츠를 추천해 드릴게요',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF718096),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Consumer<RecommendationProvider>(
            builder: (context, provider, child) {
              return ElevatedButton.icon(
                onPressed: () {
                  // 감정 대화로 이동
                  context.push('/emotion-chat');
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('감정 대화 시작하기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B73FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToContentDetail(BuildContext context, RecommendedContent content) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContentDetailScreen(content: content),
      ),
    );
  }
} 