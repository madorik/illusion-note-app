import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfessionalHelpScreen extends StatelessWidget {
  const ProfessionalHelpScreen({super.key});

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
          '전문 도움받기',
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
            // 응급 상황 경고 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFEF4444),
                    const Color(0xFFDC2626),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '응급 상황 시',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '자해나 자살 생각이 든다면 즉시 아래 번호로 연락하세요',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 응급 연락처
                  _buildEmergencyContact(
                    '생명의전화',
                    '1393',
                    '24시간 자살예방 상담',
                    Icons.phone,
                  ),
                  const SizedBox(height: 8),
                  _buildEmergencyContact(
                    '청소년전화',
                    '1388',
                    '24시간 청소년 상담',
                    Icons.phone,
                  ),
                  const SizedBox(height: 8),
                  _buildEmergencyContact(
                    '응급실',
                    '119',
                    '생명이 위급한 상황',
                    Icons.local_hospital,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 정신건강의학과 병원
            _buildSection(
              '정신건강의학과 병원',
              '전문적인 진단과 치료를 받을 수 있는 병원입니다',
              [
                _buildHospitalCard(
                  '서울대학교병원 정신건강의학과',
                  '서울 종로구 대학로 101',
                  '02-2072-2972',
                  '월-금 09:00-17:00',
                  '국내 최고 수준의 정신건강 치료',
                  4.8,
                ),
                _buildHospitalCard(
                  '삼성서울병원 정신건강의학과',
                  '서울 강남구 일원로 81',
                  '02-3410-3444',
                  '월-금 08:30-17:30',
                  '첨단 치료 시설과 우수한 의료진',
                  4.7,
                ),
                _buildHospitalCard(
                  '연세세브란스병원 정신건강의학과',
                  '서울 서대문구 연세로 50-1',
                  '02-2228-5180',
                  '월-금 09:00-17:00',
                  '오랜 역사와 전통의 정신의학과',
                  4.6,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 심리 상담센터
            _buildSection(
              '심리 상담센터',
              '전문 심리상담사와 상담을 받을 수 있는 센터입니다',
              [
                _buildCounselingCard(
                  '한국심리상담연구소',
                  '서울 강남구 테헤란로 123',
                  '02-1234-5678',
                  '개인상담, 부부상담, 가족상담',
                  '30년 경력의 전문 상담사진',
                  80000,
                ),
                _buildCounselingCard(
                  '서울심리상담센터',
                  '서울 서초구 강남대로 456',
                  '02-9876-5432',
                  '우울증, 불안장애, 트라우마 전문',
                  '인지행동치료 전문센터',
                  70000,
                ),
                _buildCounselingCard(
                  '마음치유센터',
                  '서울 마포구 월드컵로 789',
                  '02-5555-1234',
                  '청소년, 성인 심리상담',
                  '온라인 상담 가능',
                  60000,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 정신건강복지센터
            _buildSection(
              '정신건강복지센터',
              '지역사회 기반의 무료 정신건강 서비스를 제공합니다',
              [
                _buildCommunityCard(
                  '강남구 정신건강복지센터',
                  '서울 강남구 개포로 617',
                  '02-3423-7131',
                  '무료 상담, 사례관리, 재활 프로그램',
                  '무료',
                ),
                _buildCommunityCard(
                  '서초구 정신건강복지센터',
                  '서울 서초구 남부순환로 2584',
                  '02-2155-8949',
                  '정신건강 상담, 자살예방, 중독관리',
                  '무료',
                ),
                _buildCommunityCard(
                  '마포구 정신건강복지센터',
                  '서울 마포구 월드컵로 212',
                  '02-3153-9562',
                  '24시간 위기상담, 사회복귀 지원',
                  '무료',
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 온라인 상담 서비스
            _buildSection(
              '온라인 상담 서비스',
              '집에서 편리하게 전문가와 상담받을 수 있습니다',
              [
                _buildOnlineCard(
                  '트로스트',
                  '국내 최대 온라인 심리상담 플랫폼',
                  '개인상담, 부부상담, 가족상담',
                  '50,000원부터',
                  'https://trost.co.kr',
                ),
                _buildOnlineCard(
                  '마인드카페',
                  '24시간 언제든 상담 가능',
                  '텍스트, 음성, 화상 상담',
                  '40,000원부터',
                  'https://mindcafe.co.kr',
                ),
                _buildOnlineCard(
                  '힐링페이퍼',
                  '전문 심리상담사 매칭 서비스',
                  '우울, 불안, 스트레스 전문',
                  '45,000원부터',
                  'https://healingpaper.com',
                ),
              ],
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContact(String name, String number, String description, IconData icon) {
    return InkWell(
      onTap: () => _makePhoneCall(number),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name ($number)',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.call, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String subtitle, List<Widget> children) {
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
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildHospitalCard(String name, String address, String phone, String hours, String description, double rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_hospital,
                  color: Color(0xFF3B82F6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            size: 14,
                            color: index < rating.floor() 
                                ? const Color(0xFFFBBF24) 
                                : const Color(0xFFE5E7EB),
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
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
          const SizedBox(height: 12),
          
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          
          const SizedBox(height: 12),
          
          _buildContactInfo(Icons.location_on, address),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => _makePhoneCall(phone),
            child: _buildContactInfo(Icons.phone, phone),
          ),
          const SizedBox(height: 6),
          _buildContactInfo(Icons.access_time, hours),
        ],
      ),
    );
  }

  Widget _buildCounselingCard(String name, String address, String phone, String specialties, String features, int price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      features,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Text(
            specialties,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          
          const SizedBox(height: 12),
          
          _buildContactInfo(Icons.location_on, address),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => _makePhoneCall(phone),
            child: _buildContactInfo(Icons.phone, phone),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard(String name, String address, String phone, String services, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.groups,
                  color: Color(0xFF8B5CF6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        price,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Text(
            services,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          
          const SizedBox(height: 12),
          
          _buildContactInfo(Icons.location_on, address),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => _makePhoneCall(phone),
            child: _buildContactInfo(Icons.phone, phone),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineCard(String name, String description, String features, String price, String url) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
                  color: const Color(0xFF6B73FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.video_chat,
                  color: Color(0xFF6B73FF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
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
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B73FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  price,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF6B73FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Text(
            features,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          
          const SizedBox(height: 12),
          
          InkWell(
            onTap: () => _launchWebsite(url),
            child: Row(
              children: [
                const Icon(
                  Icons.language,
                  size: 16,
                  color: Color(0xFF6B73FF),
                ),
                const SizedBox(width: 6),
                Text(
                  '웹사이트 방문하기',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF6B73FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.open_in_new,
                  size: 14,
                  color: Color(0xFF6B73FF),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF6B7280),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _launchWebsite(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
} 