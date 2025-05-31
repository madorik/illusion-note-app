import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/emotion_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class EmotionInputScreen extends StatefulWidget {
  const EmotionInputScreen({super.key});

  @override
  State<EmotionInputScreen> createState() => _EmotionInputScreenState();
}

class _EmotionInputScreenState extends State<EmotionInputScreen> 
    with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  String _selectedResponseType = 'comfort';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // 디자인 시스템 색상
  static const Color _primaryColor = Color(0xFF6366F1);
  static const Color _backgroundColor = Color(0xFFF8FAFC);
  static const Color _surfaceColor = Colors.white;
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF64748B);
  static const Color _textTertiary = Color(0xFF94A3B8);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _errorColor = Color(0xFFEF4444);
  static const Color _successColor = Color(0xFF10B981);

  final List<Map<String, dynamic>> _responseTypes = [
    {
      'id': 'comfort',
      'title': '위로받고 싶어요',
      'subtitle': '따뜻한 공감과 위로가 필요할 때',
      'icon': Icons.favorite,
      'color': Color(0xFFEC4899),
      'gradient': [Color(0xFFEC4899), Color(0xFFBE185D)],
    },
    {
      'id': 'advice',
      'title': '조언이 필요해요',
      'subtitle': '실질적인 해결책을 원할 때',
      'icon': Icons.lightbulb,
      'color': Color(0xFF059669),
      'gradient': [Color(0xFF059669), Color(0xFF047857)],
    },
    {
      'id': 'empathy',
      'title': '객관적 분석이 필요해요',
      'subtitle': '사실적이고 논리적인 분석을 원할 때',
      'icon': Icons.analytics,
      'color': Color(0xFF7C3AED),
      'gradient': [Color(0xFF7C3AED), Color(0xFF5B21B6)],
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));
    
    // 포커스 상태 변화 감지를 위한 리스너 추가
    _focusNode.addListener(() {
      setState(() {}); // 포커스 상태가 변경될 때 UI 업데이트
    });
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new, 
              color: _textPrimary,
              size: 16,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '감정 기록',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 헤더 섹션
                      _buildHeaderSection(),
                      const SizedBox(height: 24),
                      // 메인 콘텐츠 영역을 Expanded로 감싸기
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 텍스트 입력 영역
                            Expanded(
                              flex: 3,
                              child: _buildTextInputSection(),
                            ),
                            const SizedBox(height: 16),
                            // AI 응답 타입 선택
                            Expanded(
                              flex: 4,
                              child: _buildResponseTypeSection(),
                            ),
                          ],
                        ),
                      ),
                      // 버튼 영역을 SafeArea 내부에 고정
                      const SizedBox(height: 20),
                      _buildAnalyzeButton(),
                      _buildErrorMessage(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘은 어떤 하루였나요?',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '당신의 마음을 자유롭게 표현해보세요',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: _textSecondary,
            height: 1.4,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildTextInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '감정 표현하기',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _focusNode.hasFocus ? _primaryColor : _borderColor,
                width: _focusNode.hasFocus ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _focusNode.hasFocus 
                      ? _primaryColor.withOpacity(0.1)
                      : Colors.black.withOpacity(0.03),
                  blurRadius: _focusNode.hasFocus ? 16 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: '오늘 중요한 발표가 있었는데 너무 긴장했어요..',
                hintStyle: GoogleFonts.inter(
                  fontSize: 15,
                  color: _textTertiary,
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(20),
                counterText: '', // 기본 카운터 숨기기
              ),
              style: GoogleFonts.inter(
                fontSize: 15,
                color: _textPrimary,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // 글자 수 카운터를 박스 밖에 표시
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${_textController.text.length}/200',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: _textController.text.length > 180 
                  ? _errorColor 
                  : _textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResponseTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI 응답 스타일 선택',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '어떤 방식으로 도움을 받고 싶으신가요?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: _textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _responseTypes.length,
            itemBuilder: (context, index) {
              return _buildResponseTypeCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResponseTypeCard(int index) {
    final type = _responseTypes[index];
    final isSelected = _selectedResponseType == type['id'];
    
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      _selectedResponseType = type['id'];
                    });
                    // 햅틱 피드백
                    HapticFeedback.lightImpact();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: isSelected 
                          ? LinearGradient(
                              colors: type['gradient'],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected ? null : _surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : _borderColor,
                        width: 1,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: type['color'].withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? Colors.white.withOpacity(0.2)
                                : type['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            type['icon'],
                            color: isSelected ? Colors.white : type['color'],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type['title'],
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : _textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                type['subtitle'],
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: isSelected 
                                      ? Colors.white.withOpacity(0.9)
                                      : _textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isSelected
                              ? Container(
                                  key: const ValueKey('selected'),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )
                              : Container(
                                  key: const ValueKey('unselected'),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _borderColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalyzeButton() {
    return Consumer<EmotionProvider>(
      builder: (context, emotionProvider, child) {
        final isEnabled = !emotionProvider.isLoading && 
                         _textController.text.trim().isNotEmpty;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16), // 버튼 아래 마진 줄임
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 56,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: isEnabled ? _analyzeEmotion : null,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: isEnabled
                        ? const LinearGradient(
                            colors: [_primaryColor, Color(0xFF4F46E5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isEnabled ? null : _borderColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isEnabled ? [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ] : null,
                  ),
                  child: Center(
                    child: emotionProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.psychology_rounded,
                                size: 20,
                                color: isEnabled ? Colors.white : _textTertiary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'AI 감정 분석 시작하기',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isEnabled ? Colors.white : _textTertiary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorMessage() {
    return Consumer<EmotionProvider>(
      builder: (context, emotionProvider, child) {
        if (emotionProvider.errorMessage != null) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 8), // 에러 메시지 위 여백 줄임
            decoration: BoxDecoration(
              color: _errorColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _errorColor.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: _errorColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    emotionProvider.errorMessage!,
                    style: GoogleFonts.inter(
                      color: _errorColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _analyzeEmotion() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final emotionProvider = Provider.of<EmotionProvider>(context, listen: false);
    
    try {
      final result = await emotionProvider.analyzeEmotionWithOpenAI(
        text: text,
        responseType: _selectedResponseType,
      );

      if (result != null && mounted) {
        _showAnalysisResult(result);
      }
    } catch (e) {
      // 에러는 EmotionProvider에서 처리됨
    }
  }

  void _showAnalysisResult(Map<String, dynamic> result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_primaryColor, Color(0xFF4F46E5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.psychology_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '분석 완료',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: _textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'AI가 당신의 감정을 분석했어요',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: _textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 28),
              
              // 감정 표시
              if (result['emotion'] != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _primaryColor.withOpacity(0.05),
                        _primaryColor.withOpacity(0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _primaryColor.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: _primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '감지된 감정',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        result['emotion'],
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: _textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              // AI 응답
              if (result['response'] != null) ...[
                Text(
                  'AI의 응답',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _borderColor,
                        ),
                      ),
                      child: Text(
                        result['response'],
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          height: 1.7,
                          color: _textPrimary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],
              
              // 버튼
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: _backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _borderColor,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '다시 입력',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: _textSecondary,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.pop(true); // 감정 입력 화면도 닫기
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [_primaryColor, Color(0xFF4F46E5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: _primaryColor.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '완료',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 