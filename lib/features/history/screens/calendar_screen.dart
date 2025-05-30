import 'package:flutter/material.dart';
import '../../../core/models/emotion_analysis_model.dart';
import '../../../core/utils/time_utils.dart';
import '../../../core/utils/emotion_utils.dart';
import '../../../services/service_locator.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentWeekStart = DateTime.now();
  DateTime? _selectedDate;
  List<EmotionPost> _selectedDatePosts = [];
  List<EmotionPost> _allPosts = [];
  bool _isLoading = false;
  bool _isCalendarCollapsed = false;

  @override
  void initState() {
    super.initState();
    final now = TimeUtils.nowInKorea();
    _selectedDate = now;
    // 이번 주의 시작일(일요일) 계산
    _currentWeekStart = _getWeekStart(now);
    _loadAllPosts();
  }

  // 주의 시작일(일요일) 계산
  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday % 7; // 0: 일요일, 1: 월요일, ...
    return date.subtract(Duration(days: weekday));
  }

  // 주의 마지막일(토요일) 계산
  DateTime _getWeekEnd(DateTime weekStart) {
    return weekStart.add(const Duration(days: 6));
  }

  Future<void> _loadAllPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 모든 기록 로드
      final recentEmotions = await services.emotionService.getRecentEmotions(count: 1000);
      setState(() {
        _allPosts = recentEmotions.posts;
      });
      
      // 선택된 날짜의 기록 필터링
      _filterPostsForDate(_selectedDate!);
    } catch (e) {
      setState(() {
        _allPosts = [];
        _selectedDatePosts = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterPostsForDate(DateTime date) {
    final filteredPosts = _allPosts.where((post) {
      final koreaPostDate = post.createdAt.isUtc ? TimeUtils.toKoreaTime(post.createdAt) : post.createdAt;
      final koreaFilterDate = date.isUtc ? TimeUtils.toKoreaTime(date) : date;
      return koreaPostDate.year == koreaFilterDate.year &&
             koreaPostDate.month == koreaFilterDate.month &&
             koreaPostDate.day == koreaFilterDate.day;
    }).toList();

    setState(() {
      _selectedDatePosts = filteredPosts;
    });
  }

  bool _hasPostsOnDate(DateTime date) {
    return _allPosts.any((post) {
      final koreaPostDate = post.createdAt.isUtc ? TimeUtils.toKoreaTime(post.createdAt) : post.createdAt;
      final koreaFilterDate = date.isUtc ? TimeUtils.toKoreaTime(date) : date;
      return koreaPostDate.year == koreaFilterDate.year &&
             koreaPostDate.month == koreaFilterDate.month &&
             koreaPostDate.day == koreaFilterDate.day;
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _filterPostsForDate(date);
  }

  void _previousWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
      // 이전 주의 첫 번째 날로 선택 날짜 변경
      _selectedDate = _currentWeekStart;
    });
    _filterPostsForDate(_selectedDate!);
  }

  void _nextWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
      // 다음 주의 첫 번째 날로 선택 날짜 변경
      _selectedDate = _currentWeekStart;
    });
    _filterPostsForDate(_selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '나의 기록',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // 달력 헤더
          _buildCalendarHeader(),
          
          // 요일 헤더
          _buildWeekdayHeader(),
          
          // 주간 달력 그리드
          if (!_isCalendarCollapsed)
            SizedBox(
              height: 80, // 높이를 고정값으로 설정
              child: _buildWeeklyCalendarGrid(),
            ),
          
          // 접기 버튼
          _buildCollapseButton(),
          
          // 선택된 날짜의 기록
          Expanded(
            child: _buildSelectedDateRecords(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    final weekEnd = _getWeekEnd(_currentWeekStart);
    String headerText;
    
    if (_currentWeekStart.month == weekEnd.month) {
      // 같은 달인 경우
      headerText = '${_currentWeekStart.year}년 ${_currentWeekStart.month}월 ${_currentWeekStart.day}일 - ${weekEnd.day}일';
    } else {
      // 다른 달인 경우
      headerText = '${_currentWeekStart.month}/${_currentWeekStart.day} - ${weekEnd.month}/${weekEnd.day}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousWeek,
            icon: const Icon(Icons.chevron_left, color: Colors.grey),
          ),
          Text(
            headerText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: _nextWeek,
            icon: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    const colors = [
      Colors.red,      // 일요일
      Colors.black,    // 월요일
      Colors.black,    // 화요일
      Colors.black,    // 수요일
      Colors.black,    // 목요일
      Colors.black,    // 금요일
      Colors.blue,     // 토요일
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: weekdays.asMap().entries.map((entry) {
          int index = entry.key;
          String weekday = entry.value;
          return Expanded(
            child: Center(
              child: Text(
                weekday,
                style: TextStyle(
                  color: colors[index],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWeeklyCalendarGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(7, (index) {
          final date = _currentWeekStart.add(Duration(days: index));
          final isSelected = _selectedDate != null &&
              _selectedDate!.year == date.year &&
              _selectedDate!.month == date.month &&
              _selectedDate!.day == date.day;
          final koreaToday = TimeUtils.nowInKorea();
          final isToday = koreaToday.year == date.year &&
              koreaToday.month == date.month &&
              koreaToday.day == date.day;

          // 요일별 색상
          Color textColor = Colors.black;
          if (index == 0) textColor = Colors.red; // 일요일
          if (index == 6) textColor = Colors.blue; // 토요일

          return Expanded(
            child: GestureDetector(
              onTap: () => _onDateSelected(date),
              child: Container(
                margin: const EdgeInsets.all(2),
                height: 70,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF7B9CDB) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : textColor,
                        fontSize: 16,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 기록이 있는 날짜에 점 표시
                    if (!isSelected && _hasPostsOnDate(date))
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCollapseButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isCalendarCollapsed = !_isCalendarCollapsed;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isCalendarCollapsed ? '펼치기' : '접기',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _isCalendarCollapsed ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDateRecords() {
    if (_selectedDate == null) {
      return const SizedBox();
    }

    final formattedDate = '${_selectedDate!.month.toString().padLeft(2, '0')}월 ${_selectedDate!.day.toString().padLeft(2, '0')}일의 기록';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedDate,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _selectedDatePosts.isEmpty
                    ? const Center(
                        child: Text(
                          '이 날에는 기록이 없습니다.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _selectedDatePosts.length,
                        itemBuilder: (context, index) {
                          final post = _selectedDatePosts[index];
                          return _buildRecordCard(post);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(EmotionPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getEmotionColor(post.emotion).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 감정 이미지
                    EmotionUtils.buildEmotionImage(
                      emotion: post.emotion,
                      size: 14,
                      fallbackIconColor: _getEmotionColor(post.emotion),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post.emotion,
                      style: TextStyle(
                        color: _getEmotionColor(post.emotion),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                TimeUtils.getRelativeTime(post.createdAt),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            post.text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case '기쁨':
      case '행복':
        return Colors.orange;
      case '슬픔':
      case '우울':
        return Colors.blue;
      case '화남':
      case '분노':
        return Colors.red;
      case '불안':
      case '걱정':
        return Colors.purple;
      case '놀람':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
} 