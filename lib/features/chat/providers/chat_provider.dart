import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _currentInput = '';
  final ScrollController scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();
  
  // 감정 샘플 목록 (실제 API 연동 전 테스트용)
  final List<String> _sampleEmotions = [
    '행복', '슬픔', '불안', '화남', '우울', '혼란', '걱정', '만족', 
    '기쁨', '슬픔', '희망', '좌절', '안도', '무기력', '설렘', '후회'
  ];

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String get currentInput => _currentInput;

  ChatProvider() {
    // 초기 메시지 추가
    _addSystemMessage('안녕하세요! 오늘 어떤 감정을 느끼고 계신가요? 편하게 이야기해주세요.');
  }

  void setCurrentInput(String value) {
    _currentInput = value;
    notifyListeners();
  }

  void addMessage(String text, MessageType type, {String? emotion}) {
    if (text.trim().isEmpty) return;

    final message = ChatMessage(
      id: const Uuid().v4(),
      text: text,
      type: type,
      timestamp: DateTime.now(),
      emotion: emotion,
    );

    _messages.add(message);
    notifyListeners();
    
    // 사용자 메시지인 경우 AI 응답 시뮬레이션
    if (type == MessageType.user) {
      _simulateAIResponse(text);
    }
    
    // 스크롤을 아래로 내림
    _scrollToBottom();
  }

  void _addSystemMessage(String text) {
    final message = ChatMessage(
      id: const Uuid().v4(),
      text: text,
      type: MessageType.system,
      timestamp: DateTime.now(),
    );

    _messages.add(message);
    notifyListeners();
  }

  // AI 응답 시뮬레이션 (실제 API 연동 전 테스트용)
  void _simulateAIResponse(String userInput) {
    // 타이핑 중 표시
    final typingMessage = ChatMessage(
      id: const Uuid().v4(),
      text: '...',
      type: MessageType.ai,
      timestamp: DateTime.now(),
      isTyping: true,
    );

    _messages.add(typingMessage);
    _isLoading = true;
    notifyListeners();
    _scrollToBottom();

    // 사용자 입력에서 감정 키워드 추출 (실제로는 AI가 분석)
    String? detectedEmotion;
    for (final emotion in _sampleEmotions) {
      if (userInput.toLowerCase().contains(emotion.toLowerCase())) {
        detectedEmotion = emotion;
        break;
      }
    }

    // 감정에 따른 응답 생성 (실제로는 AI가 생성)
    String response;
    if (detectedEmotion != null) {
      response = _generateEmotionResponse(detectedEmotion);
    } else {
      response = _generateGenericResponse();
    }

    // 딜레이 후 응답 표시 (타이핑 효과)
    Timer(const Duration(seconds: 1), () {
      _messages.removeLast(); // 타이핑 메시지 제거
      
      final aiMessage = ChatMessage(
        id: const Uuid().v4(),
        text: response,
        type: MessageType.ai,
        timestamp: DateTime.now(),
        emotion: detectedEmotion,
      );

      _messages.add(aiMessage);
      _isLoading = false;
      notifyListeners();
      _scrollToBottom();
    });
  }

  String _generateEmotionResponse(String emotion) {
    switch (emotion.toLowerCase()) {
      case '행복':
      case '기쁨':
      case '만족':
      case '설렘':
        return '행복한 감정을 느끼고 계시는군요! 그런 긍정적인 감정을 느끼게 된 계기가 있으신가요? 좋은 일이 있으셨나요?';
      case '슬픔':
      case '우울':
      case '무기력':
        return '$emotion을(를) 느끼고 계시는군요. 힘든 시간을 보내고 계신 것 같아 안타깝습니다. 더 구체적으로 어떤 상황이 이런 감정을 불러일으켰는지 이야기해주실 수 있을까요?';
      case '불안':
      case '걱정':
      case '혼란':
        return '$emotion 감정은 누구나 느낄 수 있는 자연스러운 감정이에요. 지금 어떤 상황이 이런 감정을 유발하고 있나요? 함께 이야기해보면 도움이 될 수도 있어요.';
      case '화남':
      case '불만':
      case '좌절':
      case '후회':
        return '$emotion을(를) 느끼고 계시는군요. 그런 감정을 느끼게 된 상황이 있으셨나요? 말씀해주시면 함께 생각해볼 수 있을 것 같아요.';
      default:
        return '$emotion이라는 감정을 느끼고 계시는군요. 그런 감정을 느끼게 된 이유나 상황에 대해 더 자세히 이야기해주실 수 있을까요?';
    }
  }

  String _generateGenericResponse() {
    final responses = [
      '더 자세히 말씀해주실 수 있을까요? 어떤 감정을 느끼고 계신지 이해하는데 도움이 될 것 같아요.',
      '지금 어떤 기분이신지 궁금해요. 좀 더 구체적으로 말씀해주실 수 있을까요?',
      '오늘 있었던 일에 대해 더 이야기해주실 수 있을까요? 감정을 이해하는데 도움이 될 것 같아요.',
      '지금 느끼는 감정에 영향을 준 일이 있었나요? 편하게 이야기해주세요.',
      '감정은 복잡할 수 있어요. 지금 느끼시는 감정을 좀 더 자세히 표현해주실 수 있을까요?',
    ];

    final random = DateTime.now().millisecondsSinceEpoch % responses.length;
    return responses[random];
  }

  void sendMessage() {
    if (_currentInput.trim().isNotEmpty && !_isLoading) {
      final text = _currentInput;
      textController.clear();
      setCurrentInput('');
      addMessage(text, MessageType.user);
      inputFocusNode.requestFocus();
    }
  }

  void clearChat() {
    _messages.clear();
    _addSystemMessage('새로운 대화를 시작합니다. 어떤 감정을 느끼고 계신가요?');
    notifyListeners();
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      Timer(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    inputFocusNode.dispose();
    super.dispose();
  }
} 