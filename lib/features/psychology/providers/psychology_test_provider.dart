import 'package:flutter/material.dart';
import '../../../core/models/psychology_test_model.dart';

class PsychologyTestProvider extends ChangeNotifier {
  List<PsychologyTest> _tests = [];
  PsychologyTest? _currentTest;
  int _currentQuestionIndex = 0;
  PsychologyTestResult? _testResult;
  bool _isPremiumUser = false;

  List<PsychologyTestResult> _testHistory = [];

  // Getters
  List<PsychologyTest> get tests => _tests;
  PsychologyTest? get currentTest => _currentTest;
  int get currentQuestionIndex => _currentQuestionIndex;
  PsychologyTestResult? get testResult => _testResult;
  List<PsychologyTestResult> get testHistory => _testHistory;
  bool get isPremiumUser => _isPremiumUser;
  bool get isLastQuestion => _currentTest != null && _currentQuestionIndex == _currentTest!.questions.length - 1;
  double get progress => _currentTest != null 
    ? (_currentQuestionIndex + 1) / _currentTest!.questions.length 
    : 0.0;

  PsychologyTestProvider() {
    _initTests();
  }

  // 심리 테스트 초기화 (테스트 데이터로 구현)
  void _initTests() {
    _tests = [
      PsychologyTest(
        id: 'emotion_response',
        title: '나의 감정 대응 유형 검사',
        description: '감정 상황에서 나의 반응 패턴을 알아봅니다.',
        timeEstimate: '약 3분',
        questionCount: 10,
        isPremium: false,
        thumbnail: 'assets/images/test_emotion_response.png',
        questions: _createEmotionResponseQuestions(),
      ),
      PsychologyTest(
        id: 'stress_response',
        title: '스트레스 대응 유형 검사',
        description: '스트레스 상황에서 나의 대응 유형을 분석합니다.',
        timeEstimate: '약 2분',
        questionCount: 8,
        isPremium: true,
        thumbnail: 'assets/images/test_stress_response.png',
        questions: _createStressResponseQuestions(),
      ),
      PsychologyTest(
        id: 'illusion_index',
        title: '착각지수 체크리스트',
        description: '당신의 인지 왜곡 성향을 확인해봅니다.',
        timeEstimate: '약 3분',
        questionCount: 10,
        isPremium: true,
        thumbnail: 'assets/images/test_illusion_index.png',
        questions: _createIllusionIndexQuestions(),
      ),
    ];
    notifyListeners();
  }

  // 테스트 시작
  void startTest(String testId) {
    final test = _tests.firstWhere((test) => test.id == testId);
    _currentTest = test;
    _currentQuestionIndex = 0;
    _testResult = null;
    notifyListeners();
  }

  // 테스트 종료
  void endTest() {
    _currentTest = null;
    _currentQuestionIndex = 0;
    notifyListeners();
  }

  // 다음 질문으로 이동
  void nextQuestion() {
    if (_currentTest != null && _currentQuestionIndex < _currentTest!.questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  // 이전 질문으로 이동
  void previousQuestion() {
    if (_currentTest != null && _currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  // 선택지 선택
  void selectOption(int questionIndex, int optionIndex) {
    if (_currentTest != null && questionIndex < _currentTest!.questions.length) {
      _currentTest!.questions[questionIndex].selectedOptionIndex = optionIndex;
      notifyListeners();
    }
  }

  // 테스트 완료 및 결과 계산
  void completeTest() {
    if (_currentTest == null) return;

    // 간단한 점수 기반 결과 계산 (실제로는 더 복잡한 로직이 필요할 수 있음)
    int totalScore = 0;
    int maxPossibleScore = 0;

    for (var question in _currentTest!.questions) {
      if (question.selectedOptionIndex != null) {
        totalScore += question.options[question.selectedOptionIndex!].score;
      }
      
      // 최대 가능 점수 계산 (각 질문별 최대 점수 합산)
      int maxQuestionScore = 0;
      for (var option in question.options) {
        if (option.score > maxQuestionScore) {
          maxQuestionScore = option.score;
        }
      }
      maxPossibleScore += maxQuestionScore;
    }

    // 테스트 결과 생성 (점수 비율에 따른 결과 분류)
    final scorePercentage = totalScore / maxPossibleScore;
    
    if (_currentTest!.id == 'emotion_response') {
      if (scorePercentage >= 0.8) {
        _createEmotionResponseResult('empathetic');
      } else if (scorePercentage >= 0.6) {
        _createEmotionResponseResult('analytical');
      } else if (scorePercentage >= 0.4) {
        _createEmotionResponseResult('expressive');
      } else {
        _createEmotionResponseResult('reserved');
      }
    } else if (_currentTest!.id == 'stress_response') {
      if (scorePercentage >= 0.7) {
        _createStressResponseResult('proactive');
      } else if (scorePercentage >= 0.4) {
        _createStressResponseResult('adaptive');
      } else {
        _createStressResponseResult('avoidant');
      }
    } else if (_currentTest!.id == 'illusion_index') {
      if (scorePercentage >= 0.8) {
        _createIllusionIndexResult('high');
      } else if (scorePercentage >= 0.5) {
        _createIllusionIndexResult('medium');
      } else {
        _createIllusionIndexResult('low');
      }
    }

    _testHistory.add(_testResult!);
    notifyListeners();
  }

  // 프리미엄 사용자 설정
  void setPremiumUser(bool isPremium) {
    _isPremiumUser = isPremium;
    notifyListeners();
  }

  // 테스트 결과 히스토리 가져오기
  List<PsychologyTestResult> getTestHistoryByType(String testId) {
    return _testHistory.where((result) => result.testId == testId).toList();
  }

  // ========== 테스트 데이터 생성 메서드들 ==========

  // 감정 대응 유형 테스트 질문
  List<PsychologyTestQuestion> _createEmotionResponseQuestions() {
    return [
      PsychologyTestQuestion(
        id: 'er_q1',
        question: '친구가 슬픈 일을 이야기할 때, 나는 주로:',
        options: [
          PsychologyTestOption(id: 'er_q1_a', text: '공감하며 위로한다', score: 4),
          PsychologyTestOption(id: 'er_q1_b', text: '해결책을 제시한다', score: 3),
          PsychologyTestOption(id: 'er_q1_c', text: '비슷한 경험을 나눈다', score: 2),
          PsychologyTestOption(id: 'er_q1_d', text: '화제를 전환한다', score: 1),
        ],
      ),
      PsychologyTestQuestion(
        id: 'er_q2',
        question: '중요한 일을 앞두고 불안할 때, 나는:',
        options: [
          PsychologyTestOption(id: 'er_q2_a', text: '주변인에게 감정을 솔직히 표현한다', score: 4),
          PsychologyTestOption(id: 'er_q2_b', text: '스스로 진정하는 방법을 찾는다', score: 3),
          PsychologyTestOption(id: 'er_q2_c', text: '다른 일에 집중한다', score: 2),
          PsychologyTestOption(id: 'er_q2_d', text: '감정을 무시하려고 노력한다', score: 1),
        ],
      ),
      PsychologyTestQuestion(
        id: 'er_q3',
        question: '예상치 못한 문제가 생겼을 때, 내 첫 반응은:',
        options: [
          PsychologyTestOption(id: 'er_q3_a', text: '감정적으로 동요한다', score: 1),
          PsychologyTestOption(id: 'er_q3_b', text: '차분히 상황을 분석한다', score: 4),
          PsychologyTestOption(id: 'er_q3_c', text: '다른 사람의 도움을 구한다', score: 3),
          PsychologyTestOption(id: 'er_q3_d', text: '즉시 행동에 나선다', score: 2),
        ],
      ),
      PsychologyTestQuestion(
        id: 'er_q4',
        question: '누군가 내 의견에 강하게 반대할 때:',
        options: [
          PsychologyTestOption(id: 'er_q4_a', text: '그 사람의 관점을 이해하려고 노력한다', score: 4),
          PsychologyTestOption(id: 'er_q4_b', text: '내 입장을 더 강하게 주장한다', score: 2),
          PsychologyTestOption(id: 'er_q4_c', text: '감정을 추스르고 나중에 다시 대화한다', score: 3),
          PsychologyTestOption(id: 'er_q4_d', text: '논쟁을 피한다', score: 1),
        ],
      ),
      PsychologyTestQuestion(
        id: 'er_q5',
        question: '기쁜 소식을 들었을 때, 나는:',
        options: [
          PsychologyTestOption(id: 'er_q5_a', text: '즉시 주변인과 공유한다', score: 4),
          PsychologyTestOption(id: 'er_q5_b', text: '조용히 혼자 기뻐한다', score: 2),
          PsychologyTestOption(id: 'er_q5_c', text: '특별한 방법으로 자축한다', score: 3),
          PsychologyTestOption(id: 'er_q5_d', text: '큰 감정 변화 없이 받아들인다', score: 1),
        ],
      ),
      PsychologyTestQuestion(
        id: 'er_q6',
        question: '누군가 나에게 화를 냈을 때:',
        options: [
          PsychologyTestOption(id: 'er_q6_a', text: '상대방의 감정을 이해하려고 노력한다', score: 4),
          PsychologyTestOption(id: 'er_q6_b', text: '나도 똑같이 화를 낸다', score: 1),
          PsychologyTestOption(id: 'er_q6_c', text: '상황을 논리적으로 해결하려 한다', score: 3),
          PsychologyTestOption(id: 'er_q6_d', text: '그 자리를 피한다', score: 2),
        ],
      ),
      PsychologyTestQuestion(
        id: 'er_q7',
        question: '스트레스가 심할 때, 나는 주로:',
        options: [
          PsychologyTestOption(id: 'er_q7_a', text: '감정을 표현하고 발산한다', score: 3),
          PsychologyTestOption(id: 'er_q7_b', text: '문제의 원인을 분석한다', score: 4),
          PsychologyTestOption(id: 'er_q7_c', text: '휴식을 취하거나 즐거운 활동을 한다', score: 2),
          PsychologyTestOption(id: 'er_q7_d', text: '다른 일에 몰두한다', score: 1),
        ],
      ),
      PsychologyTestQuestion(
        id: 'er_q8',
        question: '영화나 드라마를 볼 때:',
        options: [
          PsychologyTestOption(id: 'er_q8_a', text: '등장인물의 감정에 깊이 공감한다', score: 4),
          PsychologyTestOption(id: 'er_q8_b', text: '스토리의 논리적 구성을 분석한다', score: 2),
          PsychologyTestOption(id: 'er_q8_c', text: '재미있게 보되 크게 감정이입은 하지 않는다', score: 1),
          PsychologyTestOption(id: 'er_q8_d', text: '영화 속 상황에 내가 있다면 어떻게 행동할지 상상한다', score: 3),
        ],
      ),
      PsychologyTestQuestion(
        id: 'er_q9',
        question: '중요한 결정을 내릴 때, 나는:',
        options: [
          PsychologyTestOption(id: 'er_q9_a', text: '직감을 중요하게 생각한다', score: 2),
          PsychologyTestOption(id: 'er_q9_b', text: '장단점을 꼼꼼히 분석한다', score: 4),
          PsychologyTestOption(id: 'er_q9_c', text: '다른 사람의 조언을 구한다', score: 3),
          PsychologyTestOption(id: 'er_q9_d', text: '결정을 미루는 경향이 있다', score: 1),
        ],
      ),
      PsychologyTestQuestion(
        id: 'er_q10',
        question: '나는 주변 사람들에게:',
        options: [
          PsychologyTestOption(id: 'er_q10_a', text: '감정이 풍부한 사람으로 알려져 있다', score: 4),
          PsychologyTestOption(id: 'er_q10_b', text: '차분하고 이성적인 사람으로 알려져 있다', score: 3),
          PsychologyTestOption(id: 'er_q10_c', text: '실용적이고 문제 해결 능력이 뛰어난 사람으로 알려져 있다', score: 2),
          PsychologyTestOption(id: 'er_q10_d', text: '조용하고 내성적인 사람으로 알려져 있다', score: 1),
        ],
      ),
    ];
  }

  // 스트레스 대응 유형 테스트 질문 (예시)
  List<PsychologyTestQuestion> _createStressResponseQuestions() {
    return [
      PsychologyTestQuestion(
        id: 'sr_q1',
        question: '큰 업무 스트레스를 받을 때, 나는:',
        options: [
          PsychologyTestOption(id: 'sr_q1_a', text: '계획을 세워 하나씩 해결한다', score: 3),
          PsychologyTestOption(id: 'sr_q1_b', text: '휴식을 취하며 마음을 진정시킨다', score: 2),
          PsychologyTestOption(id: 'sr_q1_c', text: '가능한 피하거나 미룬다', score: 1),
        ],
      ),
      // 다른 질문들도 비슷한 형식으로 추가 (간략화를 위해 생략)
    ];
  }

  // 착각지수 체크리스트 질문 (예시)
  List<PsychologyTestQuestion> _createIllusionIndexQuestions() {
    return [
      PsychologyTestQuestion(
        id: 'ii_q1',
        question: '나는 한 번의 부정적 경험을 통해 모든 비슷한 상황을 판단하는 경향이 있다.',
        options: [
          PsychologyTestOption(id: 'ii_q1_a', text: '매우 그렇다', score: 4),
          PsychologyTestOption(id: 'ii_q1_b', text: '그렇다', score: 3),
          PsychologyTestOption(id: 'ii_q1_c', text: '그렇지 않다', score: 2),
          PsychologyTestOption(id: 'ii_q1_d', text: '전혀 그렇지 않다', score: 1),
        ],
      ),
      // 다른 질문들도 비슷한 형식으로 추가 (간략화를 위해 생략)
    ];
  }

  // ========== 테스트 결과 생성 메서드들 ==========

  // 감정 대응 유형 검사 결과
  void _createEmotionResponseResult(String type) {
    switch (type) {
      case 'empathetic':
        _testResult = PsychologyTestResult(
          testId: 'emotion_response',
          resultType: 'empathetic',
          title: '공감형',
          description: '당신은 타인의 감정을 깊이 이해하고 공감하는 능력이 뛰어납니다. 주변 사람들의 감정 변화에 민감하게 반응하며, 이들을 정서적으로 지지하는 데 능숙합니다.',
          imageUrl: 'assets/images/result_empathetic.png',
          characteristics: ['감정 이입이 강함', '타인의 감정에 민감함', '경청 능력이 뛰어남'],
          strengths: ['깊은 인간관계 형성', '갈등 중재 능력', '정서적 지원 제공'],
          weaknesses: ['감정적 소진 위험', '객관성 유지 어려움', '자신의 필요 간과 경향'],
          completedAt: DateTime.now(),
        );
        break;
      case 'analytical':
        _testResult = PsychologyTestResult(
          testId: 'emotion_response',
          resultType: 'analytical',
          title: '분석형',
          description: '당신은 감정 상황에서도 이성적이고 논리적인 접근을 선호합니다. 문제 해결에 초점을 맞추며, 감정보다는 사실과 데이터를 기반으로 결정을 내립니다.',
          imageUrl: 'assets/images/result_analytical.png',
          characteristics: ['이성적 사고 선호', '논리적 분석 능력', '객관적 시각 유지'],
          strengths: ['효율적인 문제 해결', '합리적 판단력', '감정에 휩쓸리지 않음'],
          weaknesses: ['공감 능력 부족 가능성', '타인의 감정 간과 경향', '지나친 분석으로 인한 결정 지연'],
          completedAt: DateTime.now(),
        );
        break;
      case 'expressive':
        _testResult = PsychologyTestResult(
          testId: 'emotion_response',
          resultType: 'expressive',
          title: '표현형',
          description: '당신은 자신의 감정을 솔직하고 활발하게 표현하는 성향을 가졌습니다. 감정의 기복이 뚜렷하며, 주변에 에너지를 전파하는 능력이 있습니다.',
          imageUrl: 'assets/images/result_expressive.png',
          characteristics: ['감정 표현이 자유로움', '열정적', '사교성이 높음'],
          strengths: ['진솔한 소통 능력', '긍정적 에너지 전파', '활발한 대인관계'],
          weaknesses: ['감정 조절 어려움', '충동적 결정 위험', '타인에게 과도한 영향'],
          completedAt: DateTime.now(),
        );
        break;
      case 'reserved':
        _testResult = PsychologyTestResult(
          testId: 'emotion_response',
          resultType: 'reserved',
          title: '절제형',
          description: '당신은 감정을 내면에 간직하고 신중하게 표현하는 성향입니다. 감정적 동요가 적으며, 자기 통제력이 뛰어납니다.',
          imageUrl: 'assets/images/result_reserved.png',
          characteristics: ['감정 표현 절제', '내적 성찰 선호', '차분함 유지'],
          strengths: ['안정적인 태도', '신중한 결정', '평정심 유지'],
          weaknesses: ['감정 억압 가능성', '소통 어려움', '고립감 경험 가능성'],
          completedAt: DateTime.now(),
        );
        break;
    }
  }

  // 스트레스 대응 유형 검사 결과 (간략화)
  void _createStressResponseResult(String type) {
    // 간략화를 위해 기본 결과만 생성
    _testResult = PsychologyTestResult(
      testId: 'stress_response',
      resultType: type,
      title: type == 'proactive' ? '적극 대응형' : (type == 'adaptive' ? '적응형' : '회피형'),
      description: '스트레스 대응 유형 검사 결과입니다.',
      imageUrl: 'assets/images/result_stress_${type}.png',
      characteristics: ['특성 1', '특성 2', '특성 3'],
      strengths: ['장점 1', '장점 2'],
      weaknesses: ['약점 1', '약점 2'],
      completedAt: DateTime.now(),
    );
  }

  // 착각지수 체크리스트 결과 (간략화)
  void _createIllusionIndexResult(String level) {
    // 간략화를 위해 기본 결과만 생성
    _testResult = PsychologyTestResult(
      testId: 'illusion_index',
      resultType: level,
      title: level == 'high' ? '높은 착각지수' : (level == 'medium' ? '중간 착각지수' : '낮은 착각지수'),
      description: '착각지수 체크리스트 결과입니다.',
      imageUrl: 'assets/images/result_illusion_${level}.png',
      characteristics: ['특성 1', '특성 2', '특성 3'],
      strengths: ['장점 1', '장점 2'],
      weaknesses: ['약점 1', '약점 2'],
      completedAt: DateTime.now(),
    );
  }
} 