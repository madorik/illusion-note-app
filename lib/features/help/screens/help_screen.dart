import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '도움말',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF10B981),
                    const Color(0xFF047857),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '착각노트 사용 가이드',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '착각노트를 더 효과적으로 사용하는 방법을 알아보세요',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 빠른 시작 가이드
            _buildSection(
              '빠른 시작 가이드',
              [
                _buildQuickStartStep(
                  '1',
                  '감정 기록하기',
                  '홈 화면의 + 버튼을 눌러 오늘의 감정을 자유롭게 기록해보세요.',
                  Icons.add_circle_outline,
                  const Color(0xFF6B73FF),
                ),
                _buildQuickStartStep(
                  '2',
                  'AI와 대화하기',
                  '감정 대화 탭에서 AI와 소통하며 감정을 나누어보세요.',
                  Icons.chat_outlined,
                  const Color(0xFF10B981),
                ),
                _buildQuickStartStep(
                  '3',
                  '기록 확인하기',
                  '기록 보기에서 지난 감정들을 돌아보고 패턴을 파악해보세요.',
                  Icons.history_outlined,
                  const Color(0xFF8B5CF6),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // FAQ 섹션
            _buildSection(
              '자주 묻는 질문 (FAQ)',
              [
                _buildFAQItem(
                  '착각노트는 무료인가요?',
                  '기본 기능은 모두 무료로 제공됩니다. 일부 프리미엄 기능은 추후 업데이트될 예정입니다.',
                ),
                _buildFAQItem(
                  '감정 기록은 어떻게 하나요?',
                  '홈 화면의 + 버튼을 누르거나 메뉴에서 "감정 기록"을 선택하여 오늘의 감정을 자유롭게 작성할 수 있습니다. 텍스트, 이모지, 사진 등을 활용해보세요.',
                ),
                _buildFAQItem(
                  'AI 감정 대화는 어떻게 이용하나요?',
                  '감정 대화 메뉴에서 현재 느끼는 감정을 AI와 대화할 수 있습니다. AI가 공감하고 조언을 제공하며, 24시간 언제든 이용 가능합니다.',
                ),
                _buildFAQItem(
                  '심리 검사는 얼마나 정확한가요?',
                  '심리 검사는 과학적으로 검증된 방법론을 바탕으로 제작되었지만, 참고용으로만 활용하시고 전문적인 상담이 필요한 경우 전문가와 상담하시기 바랍니다.',
                ),
                _buildFAQItem(
                  '개인정보는 안전한가요?',
                  '모든 데이터는 암호화되어 안전하게 저장되며, 개인정보 보호 정책에 따라 엄격히 관리됩니다. 사용자의 동의 없이 데이터를 공유하지 않습니다.',
                ),
                _buildFAQItem(
                  '데이터를 백업할 수 있나요?',
                  '설정에서 데이터 내보내기 기능을 통해 감정 기록을 백업할 수 있습니다. JSON 또는 PDF 형태로 내보내기가 가능합니다.',
                ),
                _buildFAQItem(
                  '오프라인에서도 사용할 수 있나요?',
                  '기본적인 감정 기록 기능은 오프라인에서도 사용 가능합니다. AI 대화나 동기화 기능은 인터넷 연결이 필요합니다.',
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 기능 가이드
            _buildSection(
              '주요 기능 가이드',
              [
                _buildFeatureGuide(
                  Icons.add_circle_outline,
                  '감정 기록',
                  '일상의 감정을 자유롭게 기록하고 AI 분석을 받아보세요.',
                  '• 텍스트, 이모지, 사진 첨부 가능\n• AI가 감정을 분석하고 피드백 제공\n• 날씨, 위치 정보 자동 기록',
                  const Color(0xFF6B73FF),
                ),
                _buildFeatureGuide(
                  Icons.chat_outlined,
                  '감정 대화',
                  'AI와 대화하며 감정을 털어놓고 공감받을 수 있습니다.',
                  '• 24시간 언제든 대화 가능\n• 개인맞춤형 조언 제공\n• 대화 기록 자동 저장',
                  const Color(0xFF10B981),
                ),
                _buildFeatureGuide(
                  Icons.psychology_outlined,
                  '심리 검사',
                  '다양한 심리 검사로 자신의 성격과 감정 패턴을 파악해보세요.',
                  '• 검증된 심리학 도구 사용\n• 상세한 결과 분석 제공\n• 개선 방안 제시',
                  const Color(0xFFEF4444),
                ),
                _buildFeatureGuide(
                  Icons.calendar_month_outlined,
                  '감정 캘린더',
                  '달력으로 감정 변화를 한눈에 확인할 수 있습니다.',
                  '• 월별/주별 감정 패턴 시각화\n• 특별한 날의 감정 기록 확인\n• 감정 트렌드 분석',
                  const Color(0xFF3B82F6),
                ),
                _buildFeatureGuide(
                  Icons.insights_outlined,
                  '통계 분석',
                  '감정 데이터를 기반으로 한 상세한 통계를 확인하세요.',
                  '• 감정 빈도 분석\n• 시간대별 감정 패턴\n• 개인 성장 지표',
                  const Color(0xFF8B5CF6),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 문제 해결
            _buildSection(
              '문제 해결',
              [
                _buildTroubleshootItem(
                  '앱이 느려요',
                  '• 앱을 완전히 종료 후 재시작\n• 기기 저장공간 확인\n• 최신 버전으로 업데이트',
                ),
                _buildTroubleshootItem(
                  '데이터가 사라졌어요',
                  '• 로그인 계정 확인\n• 인터넷 연결 상태 확인\n• 고객센터로 문의',
                ),
                _buildTroubleshootItem(
                  'AI 대화가 작동하지 않아요',
                  '• 인터넷 연결 확인\n• 앱 권한 설정 확인\n• 잠시 후 다시 시도',
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 연락처 정보
            _buildSection(
              '문의하기',
              [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '추가 문의사항이 있으시면 언제든 연락주세요.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // 이메일
                      InkWell(
                        onTap: () => _launchEmail(),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              size: 20,
                              color: Color(0xFF6B73FF),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'support@illusion.app',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF6B73FF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // 카카오톡
                      InkWell(
                        onTap: () => _launchKakaoTalk(),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline,
                              size: 20,
                              color: Color(0xFFFEE500),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '카카오톡 문의: @착각노트',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // 영업시간
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 20,
                            color: Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '고객센터 운영시간: 평일 09:00-18:00',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildQuickStartStep(String step, String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // 단계 번호
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // 아이콘
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          
          // 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGuide(IconData icon, String title, String description, String details, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              details,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTroubleshootItem(String problem, String solution) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: const Color(0xFFEF4444),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                problem,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            solution,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@illusion.app',
      query: encodeQueryParameters(<String, String>{
        'subject': '[착각노트] 문의사항',
        'body': '문의내용을 입력해주세요.',
      }),
    );
    
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  void _launchKakaoTalk() async {
    // 카카오톡 채널 또는 웹사이트로 연결
    const String url = 'https://pf.kakao.com/_착각노트';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
} 